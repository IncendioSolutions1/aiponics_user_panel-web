const apiIp = "https://control-panel.ai-ponics.com/";
const apiAddress = "${apiIp}api/users/";

const registerApi = "${apiAddress}register/";
const loginApi = "${apiAddress}login/";

const userAccountInfoApi = "${apiAddress}get-user-info/";
const checkIfUserExistsApi = "${apiAddress}get-user-id/";
const sendInvitationApi = "${apiAddress}teams/2/invite/";

const addFarmApi = "${apiAddress}create-farms/";
const updateFarmApi = "${apiAddress}farms/";
const deleteFarmApi = "${apiAddress}create-farms/";
const viewFarmsApi = "${apiAddress}farm/my-farms";

const viewDevicesApi = "${apiAddress}farms/";
const addDeviceApi = "${apiAddress}device/";
const updateDeviceApi = "${apiAddress}devices/";
const deleteDeviceApi = "${apiAddress}device/";

const viewTeamsApi = "${apiAddress}teams/user-teams/";
const addTeamApi = "${apiAddress}teams/";

const addTeamMemberApi = "${apiAddress}teams/";
const viewMembersOfSingleTeamApi = "${apiAddress}teams/";

const refreshTokenApi = "${apiAddress}token/refresh/";

const showLiveData = "wss://control-panel.ai-ponics.com/ws/live-data/";

const todosApi = "${apiAddress}todos/";