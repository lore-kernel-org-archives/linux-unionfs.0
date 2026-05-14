Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012011.outbound.protection.outlook.com [40.107.200.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FA4393DDA;
	Thu, 14 May 2026 12:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778760850; cv=fail; b=CLaKc7aVq2e7yqj5KzpFT9HJDyBDk6XHrwXnGgao4Sa6OWNibP/d8kMmy0roeJ9OOnGvOuCTm1ayX61PfmmwJCfUWyCup9UTKsMSE/ggnTL+gEVliEyLOkH3xmvOnXV92S1fvTenO1QCvBTvIAM7+NnkCBub1f7z2nxndB0SCfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778760850; c=relaxed/simple;
	bh=+qHCHBLEAV8z4caXJxcRb64J6l2jFwgsRCE5llubyPo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OULl3YOsCHMKbqCnIwheGnloDVLaOpadzhumMLAHbDoRgBMMoNdcnHhfdEhnrKnwcDjWBB7SGNMb43vMG1DxJ3nhkuKHc9vWueHAFIjYmUxkIMr6KO4UprSG6O6BjWpXEViW2GfbHL/Ba/cNEle+lPl4P4FGXg98umGl1uOqJsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mdSPEU/E; arc=fail smtp.client-ip=40.107.200.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mdSPEU/E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o7r/nVG/7UrpMsUNZmI84o94n3ZJ4W4tdt+IRDhVSl845IWPpDE4AZ1wQDDatzVNv8kaglaKj04YaWX6E9WP1smBy5qxIlXFO+xCuLkpfpLVXJX1PSgWbEHnkQUdPTaFlimliNQrPOuORpGaOpBericYUrUD2FIiwxgiMJgSUyP2vUsseDyNJpNv+LmpOd+5Ows1e3SN0j0d4w9z5SrgLp6VF9E+JjDcrMBvg7sTi973YGhI9WXVkZwfQK9/90t5AoHpOSDA2qtufwuwDw1ci6mCWpcBknTYXort5heE/mXsEqLp666QE3BTKUR654P0X3c5uBcBYpHRYyF52rmh/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/y4CJHaR5pWIJsgm1p2ELGUr05M+6JeKg+e26NrEow=;
 b=limkArahmXTwsOITLw+nDO35MxdxVDyDOA4jKbKc+niwolebQ1JVQGXkjANn/p88JW/9Y04dFh4XkrCNx+6M6FqCW6/mVq1nGUjb207D8880+I4D1ZYtbnayFHvg2aDtnOljuMJ3rjVzLo4HM9WIUSW79tElU1jhLOdi1uszx2O2LiCZlp17fVkt4HgBMbqd8DpyLnWEBLZNpshG3qKd2LrCLPGUVv/JK5xAmCoS2fGnCV27CQWiyk2HVM7AHj1X2nJ4XVQeu1U9EEkiWRxKy00u+g+OQ3rvAwjjsPRrq1hvCc7wIf49YmxxX/Z5CJ2zFCHcWIlI+L3BkCoeKGUaOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/y4CJHaR5pWIJsgm1p2ELGUr05M+6JeKg+e26NrEow=;
 b=mdSPEU/EiBpouqvSPsdnMXbmhLg7BJLebY7yIK2JuCu7ZyyT+UFgD4iGLhR7WzVs4ITawE2aQIbYMnSIU4c9hTAc1sgvbuIaVwoO1vuYcEjWhxypN97Ha9fY0UrECFt9mrzYu4b59iCXKv3xznprSKgwavwqJORWTK+JCLgAK8Bmt54J5cjVx7+RfJ8C8D6wgUaCdl4RRqoKwdtJkpLr79mJl/DRwBChuYIw/COd7xzBHbAGi/9FAX//lWkH5m8TUEOj7m9SY0hETp65gwfW6GujpR93mmGU+Krw/eO0vRQFV/0nffqUIgUbRpk+/rcmKxfTwQQrO4gckkDenhTtCA==
Received: from DSSP221CA0001.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:3d5::13) by
 IA1PR12MB6602.namprd12.prod.outlook.com (2603:10b6:208:3a2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9913.11; Thu, 14 May 2026 12:14:04 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10b6:8:3d5:cafe::93) by DSSP221CA0001.outlook.office365.com
 (2603:10b6:8:3d5::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.19 via Frontend Transport; Thu, 14
 May 2026 12:14:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Thu, 14 May 2026 12:14:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 14 May
 2026 05:13:48 -0700
Received: from 82875d6-lcedt.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 14 May 2026 05:13:48 -0700
From: Nirmoy Das <nirmoyd@nvidia.com>
To: Amir Goldstein <amir73il@gmail.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, <linux-unionfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com>, Nirmoy Das
	<nirmoyd@nvidia.com>
Subject: Re: [RFC PATCH] ovl: keep merged and impure readdir caches separate
Date: Thu, 14 May 2026 05:13:36 -0700
Message-ID: <20260514121336.439565-1-nirmoyd@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAOQ4uxg+DkTuinnf9AMR6gdHqAydbD88+oBkTtQtABJfdC0vVw@mail.gmail.com>
References: <CAOQ4uxg+DkTuinnf9AMR6gdHqAydbD88+oBkTtQtABJfdC0vVw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|IA1PR12MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d38a78-0d44-456d-463c-08deb1b24a87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|22082099003|11063799003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	hqPselhgoPp8b8jGAobxOrIPjMjk6CXb/Xd1PzLP5zzsG9RzXWvF/Fm578ko25vACFO7TLCzZ9bV5IQqTL3dA2arPgACPnuRaSSkRyopbDnvc3HD3m+KAtV9zpg1FLZxNh1p2bcapd2q29S1uRY+C/Nt5xeInzOQVwV6e0uKyufDWkVkYo1iSdtnKRiwKybf8lHmvv0xDSfx6nJ6tIyXJsKBadqU3M4hdy9zc5LczUiXRDH82OUZXCr7FkHR5olxUxteJ5ceDWuQxi3g/gSVCXr1GAVeB3OEDEg0R7AIrgVLb14EdzDYlL+xXzxB6DkDLU5iw4wvKJbVb43Tq8+p1hVwIJoW5pknGgO7US62F+PFESLPknURiDGWDITUoS2FrCGebNdIoJYqSdHLDVn2DTe+R/H3DhwO/QZChjNHlvD6Uq85jT0EnRsniEdbUsIJGyiXP1NRnDvZvIL+jejEzPvwu77tgGXvFyqEv7+02X5D8hZ+CQaiTzP7IHRal1xBn83LcPwA9xBvPq65Qwnoh/zj8bO/oa1HlGiEO2etyTl0phxfuD1pbaK7bLBFBgiD7823uoB3grt6ccT4ARbBeJ0nXGHFLE36tR3aoGRi70XmIn1haNsdXNOXjpGzcNXmrFq2srm8WrExLIMu+Q6UWmkhD2k5Asp2fsJjIMHsRo6cxC60CJxdsNjwafNbFQl3ZIN9oh9/ewFmf9KPPXmsymIY6fIUxeEc2pjTUAvoVng=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(22082099003)(11063799003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iEA19E+gG3OVKCH2T7GdHlEueAdrxFpx2T7xy8K3UR/tfxy3ARfaPFcgmLgUTua92HAW5hudgTQoHKzjybeD5FHcra9ETgB945++2uD/RwDf8FtH135G5X8chVXEAIhYPposK1NuGB0GKL0N49swld69OK5RrMUfSkLvHRjiPWHvIvDSetm1kgoL9MSLk3skKWx60Di0/6i5EAZW5UBTb6FFgwcU+pe1xeyT3u3ClsrKUdRAnI1tpy/NkY43ixUnazDaQSkshxc1xwu6Nn0aIEKHzV+cs8TzmQMGE2CYdsIyDaaPrD08+vyEKtc6groLtWOsELsS3qZEH7jFh7c3L/3aPzGwdZ4XxtJKewyl7BkR93ZVy5Ng/Z4yr0rDSG33Ui2sDjDvu80tWAc8zTBJAJzMC1KDQ3uEvFRgZJKTSV86152DTZARWTpvm9bNhaxb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 12:14:04.4449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d38a78-0d44-456d-463c-08deb1b24a87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6602

Hi Amir,=0D
=0D
After a lot of debug and traces I found another bug in=0D
ovl_iterate_merged(): err is set from PTR_ERR(cache) before the=0D
IS_ERR(cache) check, so on success err holds the truncated cache=0D
pointer.=0D
=0D
Claude generated this: =0D
  getdents64=0D
  =E2=94=94=E2=94=80=E2=94=80 iterate_dir(outer_overlay_file)=0D
      =E2=94=94=E2=94=80=E2=94=80 ovl_iterate_merged                       =
             [OUTER]=0D
          =E2=94=82=0D
          =E2=94=9C=E2=94=80=E2=94=80 cache =3D ovl_cache_get(dentry):     =
               [OUTER ovl_cache_get]=0D
          =E2=94=82   =E2=94=82   cache_local =3D kzalloc(...)=0D
          =E2=94=82   =E2=94=82   res =3D ovl_dir_read_merged(...)=0D
          =E2=94=82   =E2=94=82   =E2=94=82=0D
          =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 iterate_dir(i=
nner_overlay_file)=0D
          =E2=94=82   =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 ovl_itera=
te_merged                    [INNER]=0D
          =E2=94=82   =E2=94=82           =E2=94=9C=E2=94=80=E2=94=80 cache=
_inner =3D ovl_cache_get(...)  valid 0xFFFF8881_CAC4D940=0D
          =E2=94=82   =E2=94=82           =E2=94=9C=E2=94=80=E2=94=80 err =
=3D PTR_ERR(cache_inner)        =3D -893068992 (low32 of ptr)=0D
          =E2=94=82   =E2=94=82           =E2=94=9C=E2=94=80=E2=94=80 IS_ER=
R(cache_inner) =E2=86=92 FALSE=0D
          =E2=94=82   =E2=94=82           =E2=94=94=E2=94=80=E2=94=80 retur=
n err;                       =E2=86=90 leaked stale int=0D
          =E2=94=82   =E2=94=82=0D
          =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 return ERR_PTR(res);     =
                     res =3D -893068992 (int)=0D
          =E2=94=82                                                     sig=
n-extended =E2=86=92=0D
          =E2=94=82                                                     (vo=
id *)0xFFFFFFFF_CAC4D940=0D
          =E2=94=82=0D
          =E2=94=9C=E2=94=80=E2=94=80 err =3D PTR_ERR(cache);              =
               err =3D -893068992=0D
          =E2=94=9C=E2=94=80=E2=94=80 if (IS_ERR(cache))   =E2=86=90 FALSE:=
 IS_ERR only trips on top 4K=0D
          =E2=94=82                                  (errno window);=0D
          =E2=94=82                                  0xFFFFFFFF_CAC4D940 si=
ts below=0D
          =E2=94=82       return err;                                    =
=E2=86=90 skipped=0D
          =E2=94=9C=E2=94=80=E2=94=80 od->cache =3D cache;   =E2=98=85 corr=
upted pointer stored=0D
          =E2=94=94=E2=94=80=E2=94=80 ovl_seek_cursor(od, ctx->pos)=0D
                  list_for_each(p, &od->cache->entries)=0D
                  p =3D *(&od->cache->entries) on bad pointer     =E2=98=85=
 PAGE FAULT=0D
=0D
Sent it as a separate patch: "[PATCH] ovl: keep err zero after=0D
successful ovl_cache_get()".=0D
=0D
Let me know what you think.=0D
=0D
Regards,=0D
Nirmoy=0D
