<!DOCTYPE html>
<html>

<head>
	<title>{vtranslate('LBL_POS_WIZZARD', $MODULE)}</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<style>
		* {
			box-sizing: border-box;
		}

		html,
		body {
			margin: 0;
			padding: 0;
			height: 100%;
			font-family: Arial, Helvetica, sans-serif;
			background: #f5f5f5;
			color: #333;
		}

		.pos-toolbar {
			list-style-type: none;
			margin: 0;
			padding: 0;
			overflow: hidden;
			background-color: #333;
		}

		.pos-toolbar li {
			float: right;
		}

		.pos-toolbar a,
		.pos-toolbar .pos-toolbar-title {
			display: block;
			color: #fff;
			text-align: center;
			padding: 14px 16px;
			text-decoration: none;
			background-color: #bea364;
		}

		.pos-toolbar .pos-toolbar-title {
			float: left;
			background-color: #333;
			font-weight: bold;
		}

		.pos-toolbar a:hover {
			background-color: #a88f55;
		}

		.pos-page {
			min-height: calc(100vh - 49px);
			padding: 24px;
		}

		.pos-card {
			max-width: 1200px;
			margin: 0 auto;
			background: #fff;
			border: 1px solid #ddd;
			border-radius: 4px;
			box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
		}

		.pos-card-header {
			padding: 20px 24px;
			border-bottom: 1px solid #eee;
		}

		.pos-card-header h1 {
			margin: 0;
			font-size: 22px;
			font-weight: 600;
		}

		.pos-card-body {
			padding: 24px;
			min-height: 320px;
		}

		.pos-card-footer {
			padding: 16px 24px;
			border-top: 1px solid #eee;
			text-align: right;
		}

		.pos-btn {
			display: inline-block;
			padding: 10px 18px;
			border: 1px solid #ccc;
			border-radius: 3px;
			background: #fff;
			color: #333;
			text-decoration: none;
			cursor: pointer;
		}

		.pos-btn:hover {
			background: #f0f0f0;
		}
	</style>
</head>

<body>
	<ul class="pos-toolbar">
		<li>
			<a href="index.php?module=Contacts&view=List{if $APP}&app={$APP}{/if}">
				{vtranslate('LBL_CANCEL', $MODULE)}
			</a>
		</li>
		<li class="pos-toolbar-title">
			{vtranslate('LBL_POS_WIZZARD', $MODULE)}
		</li>
	</ul>

	<div class="pos-page">
		<div class="pos-card">
			<div class="pos-card-header">
				<h1>{vtranslate('LBL_POS_WIZZARD', $MODULE)}</h1>
			</div>
			<div class="pos-card-body">
				<div id="root"></div>
			</div>
			<div class="pos-card-footer">
				<a class="pos-btn" href="index.php?module=Contacts&view=List{if $APP}&app={$APP}{/if}">
					{vtranslate('LBL_CANCEL', $MODULE)}
				</a>
			</div>
		</div>
	</div>

	<script type="module">
		import RefreshRuntime from "http://localhost:5173/@react-refresh";

		RefreshRuntime.injectIntoGlobalHook(window);
		window.$RefreshReg$ = () => {};
		window.$RefreshSig$ = () => (type) => type;
		window.__vite_plugin_react_preamble_installed__ = true;
	</script>

	{* Locally *}
	<script type="module" src="http://localhost:5173/src/main.tsx"></script>

	{* Production *}
	<script type="module" src="http://34.170.192.250:5173/src/main.tsx"></script>
</body>

</html>