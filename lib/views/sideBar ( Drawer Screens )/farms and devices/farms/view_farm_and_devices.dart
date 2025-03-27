import 'dart:developer';
import 'package:aiponics_web_app/provider/farm%20and%20devices%20provider/view_farms_and_devices_provider.dart';
import 'package:aiponics_web_app/routes/route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aiponics_web_app/views/common/header/header_without_farm_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:skeletonizer/skeletonizer.dart';

import '../../../../models/farm and devices models/device_model.dart';
import '../../../../models/farm and devices models/farm_model.dart';
import '../../../../provider/farm and devices provider/add_device_provider.dart';
import '../../../../provider/farm and devices provider/add_farm_provider.dart';

class ViewFarmAndDevices extends ConsumerStatefulWidget {
  const ViewFarmAndDevices({super.key});

  @override
  ConsumerState<ViewFarmAndDevices> createState() => _ViewFarmAndDevicesState();
}

class _ViewFarmAndDevicesState extends ConsumerState<ViewFarmAndDevices> {
  late Color boxColor;
  late Color borderColor;
  late Color imageBorderColor;
  late Color boxHeadingColor;
  late Color buttonColor;
  late Color dividerColor;

  // Initially, no farm is selected
  String selectedFarm = "None";

  late ViewFarmsAndDevicesNotifier viewFarmNotifier;
  late dynamic viewFarmProv;

  @override
  void initState() {
    viewFarmNotifier = ref.read(viewFarmsAndDevicesProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fiveWidth = screenWidth * 0.003434;

    viewFarmProv = ref.watch(viewFarmsAndDevicesProvider);

    boxColor = Theme.of(context).colorScheme.onSecondary;
    borderColor = Theme.of(context).colorScheme.onSecondaryFixed;
    imageBorderColor = Theme.of(context).colorScheme.secondaryFixed;
    boxHeadingColor = Theme.of(context).textTheme.labelLarge!.color!;
    buttonColor = Theme.of(context).colorScheme.surfaceContainer;
    dividerColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraints) {
          log("${constraints.maxWidth}");
          if (constraints.maxWidth >= 850) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: desktopView(
                fiveWidth,
                selectedFarm,
                _updateSelectedFarm,
                0.9,
                14,
                12,
                4,
                25,
                MainAxisAlignment.spaceAround,
              ),
            );
          } else if (constraints.maxWidth >= 750) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: tabletView(
                fiveWidth,
                selectedFarm,
                _updateSelectedFarm,
                0.8,
                13,
                11,
                3,
                25,
                MainAxisAlignment.spaceAround,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: mobileView(
                fiveWidth,
                selectedFarm,
                _updateSelectedFarm,
                0.7,
                13,
                10,
                2,
                20,
                MainAxisAlignment.spaceAround,
              ),
            );
          }
        },
      ),
    );
  }

  void _updateSelectedFarm(String farm) {
    setState(() {
      selectedFarm = farm;
    });
  }

  Widget farmGrid(
    final double fiveWidth,
    final double gridWidth,
    final int itemsPerRow,
    final double nameFontSize,
    final double typeFontSize,
  ) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerRow,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / gridWidth,
      ),
      itemCount: ref.watch(viewFarmsAndDevicesProvider).areFarmsLoading
          ? 3
          : ref.watch(viewFarmsAndDevicesProvider).farmModelList.length,
      itemBuilder: (context, index) {
        var farm = ref.watch(viewFarmsAndDevicesProvider).areFarmsLoading
            ? FarmModel(
                name: '',
                farmType: '',
                crops: '',
                location: '',
                operationalStatus: '',
                farmsArea: 0.0,
                farmDescription: '',
                areaUnit: '',
                id: 0,
                cropDescription: '',
                images: null,
                owner: '',
                regDate: '',
              )
            : ref.watch(viewFarmsAndDevicesProvider).farmModelList[index];
        return
          // Skeletonizer(
          // enableSwitchAnimation: true,
          // enabled: ref.watch(viewFarmsAndDevicesProvider).areFarmsLoading,
          // child:
          farmCard(
            farm,
            fiveWidth,
            nameFontSize,
            typeFontSize,
          )
        // )
        ;
      },
    );
  }

  Widget farmCard(
    final FarmModel farm,
    final double fiveWidth,
    final double nameFontSize,
    final double typeFontSize,
  ) {
    Color boxColor = Theme.of(context).colorScheme.onSecondary;
    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              width: fiveWidth * 12,
              height: fiveWidth * 12,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), // Radius for top-left corner
                  topRight: Radius.circular(15), // Radius for top-right corner
                  bottomLeft: Radius.circular(15), // Radius for bottom-left corner
                  bottomRight: Radius.circular(15), // Radius for bottom-right corner
                ),
              ),
              child: const ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), // Radius for top-left corner
                  topRight: Radius.circular(15), // Radius for top-right corner
                  bottomLeft: Radius.circular(15), // Radius for bottom-left corner
                  bottomRight: Radius.circular(15), // Radius for bottom-right corner
                ),
                child: Image(
                  image: AssetImage("assets/images/login_image.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fiveWidth * 2, vertical: fiveWidth * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  farm.name,
                  style: GoogleFonts.poppins(
                    fontSize: nameFontSize,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  farm.operationalStatus,
                  style: GoogleFonts.poppins(
                    fontSize: typeFontSize,
                    fontWeight: FontWeight.w600,
                    color: farm.operationalStatus == "active" ? borderColor : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio<String>(
                  value: farm.id.toString(), // Unique value for this radio button
                  groupValue: selectedFarm, // Current selected value
                  activeColor: borderColor,
                  toggleable: true,
                  onChanged: (String? value) async {
                    if (value == null) {
                      setState(() {
                        selectedFarm = "None";
                      });
                    } else {
                      setState(() {
                        selectedFarm = "";
                      });
                      bool status = await viewFarmNotifier.updateSelectedFarm(farm);
                      if(status){
                        setState(() {
                          selectedFarm = value;
                        });
                      }

                    }
                  },
                ),
                IconButton(
                  onPressed: () {
                    ref.read(addFarmProvider.notifier).updateFarmModel(farm);
                    ref.read(addFarmProvider.notifier).updateIsEditing(true);
                    Get.toNamed(TRoutes.addFarms, arguments: true);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(), // Remove default constraints
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget deviceGrid(
    final double fiveWidth,
    final double gridWidth,
    final int itemsPerRow,
    final double nameFontSize,
    final double typeFontSize,
  ) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerRow,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / gridWidth,
      ),
      itemCount: ref.watch(viewFarmsAndDevicesProvider).areDevicesLoading
          ? 3
          : ref.watch(viewFarmsAndDevicesProvider).deviceModelList.length,
      itemBuilder: (context, index) {
        var device = ref.watch(viewFarmsAndDevicesProvider).areDevicesLoading
            ? DeviceModel(
                id: 0,
                name: '',
                deviceType: '',
                imeiOrApiKey: '',
                farm: 0,
                numFans: 0,
                numCoolingPumps: 0,
                numWaterSupplyPumps: 0,
                numLights: 0,
                numHumiditySensors: 0,
                numTemperatureSensors: 0,
                waterTankSize: 0,
            deviceId: ''
              )
            : ref.watch(viewFarmsAndDevicesProvider).deviceModelList[index];
        return
          // Skeletonizer(
          // enableSwitchAnimation: true,
          // enabled: ref.watch(viewFarmsAndDevicesProvider).areDevicesLoading,
          // child:
          deviceCard(
            device,
            fiveWidth,
            nameFontSize,
            typeFontSize,
          )
        // )
        ;
      },
    );
  }

  Widget deviceCard(
    final DeviceModel device,
    final double fiveWidth,
    final double nameFontSize,
    final double typeFontSize,
  ) {
    Color boxColor = Theme.of(context).colorScheme.onSecondary;
    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              width: fiveWidth * 12,
              height: fiveWidth * 12,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), // Radius for top-left corner
                  topRight: Radius.circular(15), // Radius for top-right corner
                  bottomLeft: Radius.circular(15), // Radius for bottom-left corner
                  bottomRight: Radius.circular(15), // Radius for bottom-right corner
                ),
              ),
              child: const ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), // Radius for top-left corner
                  topRight: Radius.circular(15), // Radius for top-right corner
                  bottomLeft: Radius.circular(15), // Radius for bottom-left corner
                  bottomRight: Radius.circular(15), // Radius for bottom-right corner
                ),
                child: Image(
                  image: AssetImage("assets/images/login_image.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fiveWidth * 2, vertical: fiveWidth * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: GoogleFonts.poppins(
                    fontSize: nameFontSize,
                  ),
                ),
                SizedBox(height: fiveWidth * 1),
                Text(
                  device.deviceType,
                  style: GoogleFonts.poppins(
                      fontSize: typeFontSize, color: Colors.blueGrey, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.online_prediction,
                    color: Colors.green,
                    size: 25,
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(addDeviceProvider.notifier).updateDeviceModelFull(device);
                      ref.read(addDeviceProvider.notifier).updateIsEditing(true);
                      Get.toNamed(TRoutes.addDevice, arguments: true);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(), // Remove default constraints
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget desktopView(
    final double fiveWidth,
    final String selectedFarm,
    final Function(String) onFarmSelected,
    final double gridValue,
    final double nameFontSize,
    final double typeFontSize,
    final int itemsPerRow,
    final double mainHeadingSize,
    final MainAxisAlignment mainAxisAlignment,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomHeaderWithoutFarmDropdown(
          mainPageHeading: 'Welcome',
          subHeading: 'View and Manage your Farm & Devices',
        ),
        const SizedBox(height: 25),
        Text(
          "Farms",
          style: GoogleFonts.inter(
            fontSize: mainHeadingSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 30),
        ref.watch(viewFarmsAndDevicesProvider).farmModelList.isEmpty &&
                !ref.watch(viewFarmsAndDevicesProvider).areFarmsLoading
            ? const Center(
                child: Text("No Farms Found"),
              )
            : SizedBox(
                height: ref.watch(viewFarmsAndDevicesProvider).areFarmsLoading
                    ? 100
                    : 100 *
                        (ref.watch(viewFarmsAndDevicesProvider).farmModelList.length / itemsPerRow)
                            .ceilToDouble(),
                child: farmGrid(
                  fiveWidth,
                  gridValue,
                  itemsPerRow,
                  nameFontSize,
                  typeFontSize,
                )),
        const SizedBox(height: 40),
        Text(
          "Devices",
          style: GoogleFonts.inter(
            fontSize: mainHeadingSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 30),
        ref.watch(viewFarmsAndDevicesProvider).deviceModelList.isEmpty &&
                !ref.watch(viewFarmsAndDevicesProvider).areDevicesLoading &&
                selectedFarm != "None"
            ? Center(
                child: Text(
                  "No Devices Found for this farm.",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            : selectedFarm == "None"
                ? Center(
                    child: Text(
                      'No farm selected right now!',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: ref.watch(viewFarmsAndDevicesProvider).areDevicesLoading
                        ? 100
                        : 100 *
                            (ref.watch(viewFarmsAndDevicesProvider).deviceModelList.length /
                                    itemsPerRow)
                                .ceilToDouble(),
                    child: deviceGrid(
                      fiveWidth,
                      gridValue,
                      itemsPerRow,
                      nameFontSize,
                      typeFontSize,
                    )),
      ],
    );
  }

  Widget tabletView(
    final double fiveWidth,
    final String selectedFarm,
    final Function(String) onFarmSelected,
    final double gridValue,
    final double nameFontSize,
    final double typeFontSize,
    final int itemsPerRow,
    final double mainHeadingSize,
    final MainAxisAlignment mainAxisAlignment,
  ) {
    return desktopView(
      fiveWidth,
      selectedFarm,
      onFarmSelected,
      gridValue,
      nameFontSize,
      typeFontSize,
      itemsPerRow,
      mainHeadingSize,
      mainAxisAlignment,
    );
  }

  Widget mobileView(
    final double fiveWidth,
    final String selectedFarm,
    final Function(String) onFarmSelected,
    final double gridValue,
    final double nameFontSize,
    final double typeFontSize,
    final int itemsPerRow,
    final double mainHeadingSize,
    final MainAxisAlignment mainAxisAlignment,
  ) {
    return desktopView(
      fiveWidth,
      selectedFarm,
      onFarmSelected,
      gridValue,
      nameFontSize,
      typeFontSize,
      itemsPerRow,
      mainHeadingSize,
      mainAxisAlignment,
    );
  }
}
