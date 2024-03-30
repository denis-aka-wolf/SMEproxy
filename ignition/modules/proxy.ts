import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const UpdateProxy = buildModule("UpdateProxy", (m) => {
  
  //Раскомментировать если библиотека задеплоена
  //const dynamicRouterStorage = m.contractAt("DynamicRouterStorage", "0x...");

  //Закомментировать если есть задеплоенная библиотека
  const dynamicRouterStorage = m.library("DynamicRouterStorage");

  const updateProxy = m.contract("UpdateProxy", [], {
  libraries: {
      DynamicRouterStorage: dynamicRouterStorage,
    },
  });

  return { updateProxy };
});

export default UpdateProxy;
