<!doctype html>
<html lang="fr">

<head>
    <title>Hotel</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="{{ asset('css/app.css') }}" rel="stylesheet">
</head>

<body class="relative">

    <nav class="sticky top-0 z-50">
        <div class="w-full flex float-right pl-4 relative mb-20 mt-3">
            <img src="{{ asset('images/logo.png') }}" alt="logo" class="vatar w-14 rounded-full">
        </div>
    </nav>
    <div class="w-full h-full absolute
     bg-gradient-to-t from-amber-600 to-yellow-500 opacity-60"></div>
    <div class="w-full min-h-screen bg-no-repeat bg-center bg-cover p-4"
        style=" background-image: url('{{ asset('images/hotel.jpg') }}');">

        <div class="relative mt-40 md:mt-24 w-full">
            <div class="pl-4 mt-32 text-white">
                <span class="text-2xl font-medium">Bienvenue dans l'hotel de luxe 5 étoiles</span>
            </div>
            <div class="pl-4 mt-2 text-white space-y-3">
                <p class="lg:text-7xl md:text-6xl sm:text-6xl font-medium">Loger dans un cadre</p>
                <p class="text-6xl font-medium">paisible et contable</p>
            </div>
        </div>
        <div class=" relative mt-10">
            <div class="pl-4 mt-2 text-white">
                <span class="text-xl font-medium">Les pus vistes</span>
            </div>
        </div>
        <div class=" max-w-lg relative mt-4 flex justify-start gap-2">
            <div class="overflow-hidden shadow-lg bg-white rounded-lg p-2">
                <img src="{{ asset('images/hotel.jpg') }}" alt="logo" class="w-full rounded-lg h-28">
                <div class="px-6 py-4">
                    <div class="font-bold text-sm mb-1">The title</div>
                    <p class="text-gray-700 text-sm">
                        Lorem ipsum dolor sit amet.
                    </p>
                </div>
            </div>
            <div class="overflow-hidden shadow-lg bg-white rounded-lg p-2">
                <img src="{{ asset('images/hotel.jpg') }}" alt="logo" class="w-full rounded-lg h-28">
                <div class="px-6 py-4">
                    <div class="font-bold text-sm mb-1">The title</div>
                    <p class="text-gray-700 text-sm">
                        Lorem ipsum dolor sit amet.
                    </p>
                </div>
            </div>
            <div class="overflow-hidden shadow-lg bg-white rounded-lg p-2">
                <img src="{{ asset('images/hotel.jpg') }}" alt="logo" class="w-full rounded-lg h-28">
                <div class="px-6 py-4">
                    <div class="font-bold text-sm mb-1">The title</div>
                    <p class="text-gray-700 text-sm">
                        Lorem ipsum dolor sit amet.
                    </p>
                </div>
            </div>
        </div>
    </div>
</body>

</html>
