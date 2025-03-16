'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "3302e0757643c2689294782597c58e19",
".git/config": "bddb934d2929295f2cc13dc849d102a7",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "8c751feffc22d08fbf1b46cc8eb1826b",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "21015a2a2e899e4ce1b7fecaa9a39253",
".git/logs/refs/heads/gh-pages": "baeadf2c66c763775c02fad524351113",
".git/logs/refs/remotes/origin/gh-pages": "2ae3ed9a634a25eddf479c2d48ffc989",
".git/objects/03/2fe904174b32b7135766696dd37e9a95c1b4fd": "80ba3eb567ab1b2327a13096a62dd17e",
".git/objects/04/d3c966c4c4a3585ec779cab3f75f87a44ee341": "9d7c59d3b3853ff86bba2aa4b62f6c44",
".git/objects/10/4c601cd51f452a0121e7f10eeac6900dfe8a20": "97e8ac2dac47371d1d9e24e5e25e4107",
".git/objects/1c/3306f2e578e8b31808fe4e3362ec26b3e50add": "f9890f699df44e28d5365360a0d66ec1",
".git/objects/1e/f433cd72dfe0ecebb3f31e84016362794e3eaf": "757f9ff48e2b79d977c90e65d6ee46cf",
".git/objects/1f/a3b50be7f2dbe746cce677245996c95e7bbcd5": "a62a9be6e587bb7809850970fa9db43d",
".git/objects/26/591c86fe1d2da0df70b355d10faee5d6f6ad44": "8efb6b7b9c239c846988e8e36c28e9dd",
".git/objects/27/b055dda7b6971e1f01cb359ad8142b2c01e13f": "4d262fe7a81ac2551c2996abe10000ba",
".git/objects/2c/ec860ded0c08f30a72b0ef24906b7b72ea7dc1": "7dfdfdaa6be91ee2fc6980a972ab7b56",
".git/objects/2f/9da78bb05b967f4f3d0cc87edbd66428878eb1": "3f0efa2379a82baa7ebdbd9b531971bc",
".git/objects/33/31d9290f04df89cea3fb794306a371fcca1cd9": "e54527b2478950463abbc6b22442144e",
".git/objects/35/765109bdc99a822adbac393293f3de57eddab0": "6c631b443f9f16fcbf8878e6e4cdfa6c",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/3a/a1c0b05863eb637d3a27a11006e891c55c5333": "15fee1089495dc35d480964d9e29cf20",
".git/objects/3b/9b999ee19a3afa638ef641d85022cdf4839efe": "508457eeb810843d87e17c7ce55f25a7",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/4f/02e9875cb698379e68a23ba5d25625e0e2e4bc": "254bc336602c9480c293f5f1c64bb4c7",
".git/objects/4f/072bffc3481af6efa0a894bf3c3102171e285d": "1abd89581c1175945df357263d1417bb",
".git/objects/52/e329734721d5c5ed3916923dc2a251269a5576": "3c3ee80f577e706b40677aafd447191e",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/57/f4265bac24c9a6894c7c87a9ad8c79878c97d0": "1dfd0e712f3357d8eafdd65bce61cb9e",
".git/objects/5c/b4719d08983636800a3dec8215a017c8c28856": "1d56241513310c3242795a15c0ebf97e",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/64/5116c20530a7bd227658a3c51e004a3f0aefab": "f10b5403684ce7848d8165b3d1d5bbbe",
".git/objects/67/56d3e765f052a12d985aeb689fddf31d2cd121": "3ba2b02ac0e00d16f768d8ca437867c5",
".git/objects/6a/5679e2ed6224a3b358fdaf582d9131dae59110": "3ef3ce07a69849acf07214f2ab3f459a",
".git/objects/6b/97d22a07b695865319a46da723ee20270aff1b": "fb15cf3db1847291f4cc51a0eec7ba23",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8e/009b08eff3eac578289aa99e36644c99f7d162": "ec84114d73339e86fbd045613bc68316",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/9b/da5791d6a627028d7077bbf4b9b54c939d020d": "12fc82f4f172ff329c5c2700bf52269a",
".git/objects/9f/621a67d310ece6add62bfe33d4838b26da1f00": "384dbe42f247a0093427511693814978",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/a5/f392788c7fc202635e3bbdb9ddf086b4bba3b5": "0b44bf677f2c56374068d7f159742958",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/af/f54a6493e5cb5f624e6b2c426ee9b3a4c10fa9": "1495f6dcf9e1fbb2d06031a57d91093a",
".git/objects/b6/0c5f29b0e8e766c3b7b6e771685fdb5b4eb28e": "bf245b454c9b7ba43a0c1faf69ee43e7",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b7/8ca28c1e53bd9be267ea5956e37e9abee7242d": "c9dd9b1065b2f6d4d52cb5ef25415db0",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/c1/6c63396723eb0de24cfd5ac0c2afcc749f40a3": "9a5d4b98aafa1ea58a36c4ac11fc7c2f",
".git/objects/d3/1b2f98cd0f1c88db291a6ce47af3edbf6d691c": "0f8d338b1d3e9356d5365f5d2aa6261f",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/e4/179ab698099a409bd8b9cf9d849752fce14bc4": "aa499cf807915356cb0b1de52ec9f3b5",
".git/objects/e7/3fc15dd87b86892b394479dcd6c34f9475c081": "95e7aa8b70e093a0c597d7f3b3ede79a",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ed/e07f44d7dd29bad4b2ac819147cdc30bb9ee81": "89b66232bdbc6b4e478da6788161ad0f",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f2/06e5122e03648ae676f7f272621b58571aa49c": "fe287b85fba39221fc17d2ccf3081300",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/f3/d46a32e06fc8e995b535d47d97efd7f573c407": "98a213699b6ccedf3c0d441dff3dcd31",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/f7/97b5b17661a08fc48636e691174d9871c73429": "b12c5a1345c2dad7fa3b7acae0849543",
".git/objects/fb/04cb6862d8a835f60d51197b99a62226ad1ecc": "0e4475f4c5e3eeafc86d8efcd0522fc8",
".git/refs/heads/gh-pages": "167bbcc08d95867d7bec9591c8585feb",
".git/refs/remotes/origin/gh-pages": "167bbcc08d95867d7bec9591c8585feb",
"assets/AssetManifest.bin": "ace17d1a30a0ef513ee92191ac7ed195",
"assets/AssetManifest.bin.json": "5fb33ad222f90c66e7f76f9836fb7f0f",
"assets/AssetManifest.json": "06ad202cacc173ecb31625aff230e29e",
"assets/assets/MATERNO-2025.csv": "4b4bcef45253d886ed0e2a66ae80e8f1",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "54ab7a28c8f589533639550bddcf18b8",
"assets/MATERNO-2025.csv": "4b4bcef45253d886ed0e2a66ae80e8f1",
"assets/NOTICES": "61d43a060f1eb9b81a487f04dfc6e0fb",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "e899fde2569124ea466261c1ee9ae5e6",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "6b9a7ec445d188369cb1f2959e0b9a4c",
"/": "6b9a7ec445d188369cb1f2959e0b9a4c",
"main.dart.js": "9678649ad0a78ca87bad7851d4a3441d",
"manifest.json": "0abb4c793cc0c2d19c33b68b427b5210",
"version.json": "c941ba1d397faacb9f79fd6c252023e6"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
