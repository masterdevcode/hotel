<!doctype html>
<html lang="fr">

<head>
    <title>Hotel</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="{{ asset('css/app.css') }}" rel="stylesheet">
</head>

<body>
    <div class="w-full h-full absolute bg-gradient-to-tr from-amber-600 to-yellow-500 opacity-60"></div>
    <div class="w-full h-screen bg-no-repeat bg-center bg-cover p-8"
        style=" background-image: url('{{ asset('images/hotel.jpg') }}');">
        <div class="w-full flex float-right pl-4 relative mb-20">
            <img src="{{ asset('images/logo.png') }}" alt="logo" class="vatar w-14 rounded-full">
        </div>
        <div class="relative mt-40">
            <div class="pl-4 mt-32 text-white">
                <span class="text-2xl font-medium">Bienvenue dans l'hotel de luxe 5 étoiles</span>
            </div>
            <div class="pl-4 mt-2 text-white space-y-3">
                <p class="text-7xl font-medium">Loger dans un cadre</p>
                <p class="text-6xl font-medium">paisible et contable</p>
            </div>
        </div>

        <div class="mt-8 relative mb-4">
            <div class="max-w-xs overflow-hidden shadow-lg bg-white rounded-lg p-4">
                <img src="{{ asset('images/hotel.jpg') }}" alt="logo" class="w-full rounded-lg">
                <div class="px-6 py-4">
                    <div class="font-bold text-xl mb-1">The title</div>
                    <p class="text-gray-700 text-base">
                        Lorem ipsum dolor sit amet.
                    </p>
                </div>
            </div>

        </div>

</body>

</html>
