import 'package:nyan_vpn_app/data/vos/server_vo.dart';
import 'package:nyan_vpn_app/utils/vpn_config.dart';

List<ServerVO> dummyServerList = [
  ServerVO(
    id: 1,
    countryName: "Singapore",
    flag: "assets/images/singapore_flag.png",
    userName: "sshmax-nyanwinnaing",
    password: "",
    config: sgConfig,
    isSelected: false,
  ),
  ServerVO(
    id: 2,
    countryName: "Thailand",
    flag: "assets/images/thailand_flag.png",
    userName: "",
    password: "",
    config: thailandConfig,
    isSelected: false,
  ),
  ServerVO(
    id: 3,
    countryName: "Australia",
    flag: "assets/images/australia_flag.jpg",
    userName: "sshmax-nyanwinnaing",
    password: "",
    config: australiaConfig,
    isSelected: false,
  ),
  ServerVO(
    id: 4,
    countryName: "South Korea",
    flag: "assets/images/korea_flag.jpg",
    userName: "",
    password: "",
    config: koreaConfig,
    isSelected: false,
  ),
];
