Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1ACBC433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 06:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B5361528
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 06:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348384AbhI3GyV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 02:54:21 -0400
Received: from mail-eopbgr1320040.outbound.protection.outlook.com ([40.107.132.40]:15360
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347826AbhI3GyU (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Sep 2021 02:54:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWVdmiB723u1bKHeu9fhM6cusqe4GRFAs6k4CxbkIv2wt+S+KicEXdmZSOJM1rmXswBMl4MXuErQz9PsOIsfe7I4adMUU9LW85mlpLjg3DsoErf7Rmi7QB0kKNYGEolg862pz8EDZbz6I3EsUZ+Avtd1bmFAStfnojldwyEvxwzeKl4k9Ym8DaD74Vd81Gm9QyIWOh4OkKAse2jHOqFL+ytos6xdh4/qPueTvh7BvHz7tvu2CcVSiDsc64dF/92iDaj19qSt/rcZKN+r3tyewRHGzrJuPtWJOud6k6pNJqpK9pPLq2/02ggH7gHdj6fqITxmDijkpPnccD9nwxEyRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KZYkIeMkJ0qBiySSwsa5Z4C1DE6yb2EjEBMInQNlTfM=;
 b=TS/h9OfI042GrewcI3IbRGlYYihhRpB+fAKyNfoPh5PB8/6vuAxibhs0sUo3bn3D+0OIL7qbF38FutMN6oIny+tJQw4BALlmsx1acDgPV8xlfo4QwujdcsjxstQV5qUw6R2/ZTXIv+w9vsiNV9hpea/8H89Cv450+wADpJTN+xjn4xAK6PS3HPboko2sGeEapVn5BnsaE6m8+TzPLjKWdT+KgwCqnd0VjI9fI0/dPZhV38c070KKr05rAXGIndg5wJRCPo+UgXHB13/TS3Ou+fGjajxGNBGKWioODK2nTVc4LeLNgpA2+mEM52jIIleY+NCuK9zAY8MnHSFoY9sIzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZYkIeMkJ0qBiySSwsa5Z4C1DE6yb2EjEBMInQNlTfM=;
 b=aIAJYdxm2SvIxxjNgJsd2dQc/4EtsnCN9RS2q8+yjoDO20mMwAqC7C7jnvc+cTx+Mh/cPrnDYrLHedwEUiYOxUtVTEMvbt13kdyv9+2cpBNnT0dkrkV9nzUtanC9Gnj5s0OqhIGq2nUW4eZ1TOxk9HiE/Ncec+QNifsxHVCPnVs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oppo.com;
Received: from SG2PR02MB4108.apcprd02.prod.outlook.com (2603:1096:4:96::19) by
 SG2PR02MB2382.apcprd02.prod.outlook.com (2603:1096:3:1c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.14; Thu, 30 Sep 2021 06:52:33 +0000
Received: from SG2PR02MB4108.apcprd02.prod.outlook.com
 ([fe80::5919:768f:2950:9504]) by SG2PR02MB4108.apcprd02.prod.outlook.com
 ([fe80::5919:768f:2950:9504%4]) with mapi id 15.20.4544.022; Thu, 30 Sep 2021
 06:52:33 +0000
Subject: Re: [PATCH] ovl: set overlayfs inode's a_ops->direct_IO properly
To:     Chengguang Xu <cgxu519@mykernel.net>, mszeredi@redhat.com
Cc:     linux-unionfs@vger.kernel.org
References: <20210928124757.117556-1-cgxu519@mykernel.net>
From:   Huang Jianan <huangjianan@oppo.com>
Message-ID: <2ef5a5e3-234f-5b1b-5463-726d200e7e96@oppo.com>
Date:   Thu, 30 Sep 2021 14:52:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20210928124757.117556-1-cgxu519@mykernel.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR02CA0170.apcprd02.prod.outlook.com
 (2603:1096:201:1f::30) To SG2PR02MB4108.apcprd02.prod.outlook.com
 (2603:1096:4:96::19)
MIME-Version: 1.0
Received: from [10.118.7.229] (58.255.79.105) by HK2PR02CA0170.apcprd02.prod.outlook.com (2603:1096:201:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 06:52:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08e81272-0e0f-4be9-4e78-08d983dee0aa
X-MS-TrafficTypeDiagnostic: SG2PR02MB2382:
X-Microsoft-Antispam-PRVS: <SG2PR02MB2382554CBD8AD77A1953346FC3AA9@SG2PR02MB2382.apcprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: px1XCit4NY0/D7GXuu5hYxGlHSsl3SRchYFWfykkWQbopOusNAOszlVjAtzGtZ3iIaiFKy10P2585m8RWj3uWkPlniWQttBKKFHsBYqqNOZ3lXm4heq/fEUigUf3i1DfCZsRDjlBIkos6iurInSJ38TSXvy/jRNGTzZFkOJ5U/oD6VwBsYE3qkwHgWegPPlhsa64Ll+oeW6h8RT5rQqn6wV/PqKf4X6tzXU4eMwpWWnnvY1hKqu4F//AdqM2rmMpAPS1a2CeDTlzGMULS+MhFuj9CTL/C5n7GlpH/LbG94O/8XfEgQI6PhrLSSw/Qg1k9EtWC8toJZ/TSPvx0mKKIbFO52uhiluDldMFSTFMNeJJ1sBLtyeFYLh68zLjGMriQJLe9FoEUp4oCOcr0vwiW9flnZZfIavlElVUiUu3eE356MVMU77yFxtTJUPTxt7Bu4Mynr5uouyeRPMco5a2+MdI8Zsq7qnj6CTILV6M+65DIReXRvF3ATKvniSI/L02uk8vqOyhmrf47ORUSgr2gSysNuRTR/7tJNabtQl/3nFIt0c+qOx3SKYt8u6lqezSYN5yob3zGR2U8VcNArQqsmL1zyLxhztgB+ewRZ6sDw8obz5YjP4bf/BL89kpk8AanqZSEh4lGrEJndEO6dnYMNImxEpCI7nosUfFk+8ar1wnnH8aMazM21AlwLOGTXFjvHacyiTRZXO+qVEkeyl+e1f5s1zwc/iQyUsDCTtXGcQMU4d6Kp8L1pPYBzlpEeH6ZUp3hf76Tgp1qX2aKpEaTXex9Q5X7sL3IhwvbDn4d+M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR02MB4108.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(2906002)(956004)(31696002)(2616005)(38100700002)(5660300002)(38350700002)(8936002)(31686004)(66946007)(66476007)(83380400001)(186003)(66556008)(52116002)(26005)(6486002)(36756003)(508600001)(4326008)(316002)(8676002)(16576012)(11606007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S29oNHdaQzJIaWRiRkVtRUZhekUxQThTT0Y5UkZRbnliWWZxTkNBdFFnWHFF?=
 =?utf-8?B?SkhyTnNlaDlpOU1hTDF3YzRPaG12SXNSNkhjQk43UDN5ZTZNVmhSdnhOY3Vr?=
 =?utf-8?B?eVVUbTVTZjA4cy9Bbmx0bHQxVXFmQ09iY2FSa01KaVAvUGQ2Mi9CWXNvSDJB?=
 =?utf-8?B?amZSaThYbDV2RGxobHh4RVRLeTJSYWQvaXZpSElBWG1ZWisxOThTRGwxSXBu?=
 =?utf-8?B?bnlqTCtZV2YvU3pUZWpUcWx5c3Nscy9EbzB1dHVYajVGTEdZZTEwZWNJOWNs?=
 =?utf-8?B?Q2sycTduV2QrWVNZRnA2RXB3cEk3MDczdzV0SHhKK25kMEdJMW9ZYk9ZRDNo?=
 =?utf-8?B?VVpUSkVocnRhREJpVlgybzBnaXJPVm1lS2tGUkZvRzE2RFcrbFQ2bW0xS25m?=
 =?utf-8?B?YjBoMDV5TDF6ZktEbTVzK2ZLVnRCUTFHcWRSaFVHaXRKb2VkWkVXdFNaMUFI?=
 =?utf-8?B?ekFsUGo3cWhsRTd6TTNVRUhpUzRHeU1LVGtKUlRlaUphN2kwcldpUEhDZUhy?=
 =?utf-8?B?RXc0MHBVMlYvdGNUTHhWRDlrQ1lwQzVmM0U5NCttWG16RHYyYUl0YW9RVVJH?=
 =?utf-8?B?dEVmciswbU9EMVFucmlqTDBVVG0rV2xFUytPZXdDS3k0YStIMXdCRk5hYUdl?=
 =?utf-8?B?c2M1VHRGY1NnVWRUWjRIN05MeEZyc2RGd1Zham1ZV3BwVkJKZHgrNnVYei8w?=
 =?utf-8?B?czZkZFJGa2VEWUl2dEJLVDhFeUo2TzlkcDdsTUU0c05lM0RXWG1iVGJXbUxP?=
 =?utf-8?B?RlAyS21XWHYyOCtRZk54dmVVRS9rQWFmMk5YVjZkdk9kL0QrTVZ6TGJLUGRo?=
 =?utf-8?B?M2RSR1JoaXNRdnJ5WGpUbnFDdmc2bzFialkzN2hVaHlRb1Z0TXZrMXd6Tlhi?=
 =?utf-8?B?enArQkJnRFRMQldSdGZNM1lCZ1l1Mmt2MXBKTlM4L0lMUXA3azdPamNLTERC?=
 =?utf-8?B?MUhNMlhzc3ZPZDlYM3dyNS9XQ0hMNElOUW50Qy8waHBpY0NOV2w0YVJMYzhs?=
 =?utf-8?B?TTR3QVlVcGtSWjFnbG90WjlFT2ppVG9kRTNxOW9uampnS2wzeHErWFZPM2xZ?=
 =?utf-8?B?MWhrVHBYSGVGd1JvWVBzSFJSQjRPNFBQY3dtVEJIdHlTVTdxbkZPd3NRa1ZF?=
 =?utf-8?B?ZS80dnM4cGh2ZDVic2h0SDRGSGRwVHpmc29zaEc0Tm9HQ3M3S1hMYlZyankv?=
 =?utf-8?B?bTZtenBxVmN3UmMyMGVkOU5BTnM5Ums0Qzg3RDA4UG5BYlJ2OU05Z0lFSzFD?=
 =?utf-8?B?UlAyaE1TdFJxTEVabTdHbG9QcFJmZkp5SXdCY0g5ZlR6STRpeXpTWnBWNEJT?=
 =?utf-8?B?eFAzZlZJbmtWbVBUMnQzTVJBTENCM0IyeWg2KytxbUQ1NnNzWUc4QzBJKzdk?=
 =?utf-8?B?cTNBUmgyZi8rdTZXTVJYM3ZKT1ErTTAyb0xvcDlTa2F2eEc2S2phNnIvV0F1?=
 =?utf-8?B?RklRMHNTTEFxVk9lTU1qWDFQSmhaeUhpZFM4QjUxdjc1ZE5iSWgzRWcwVzRC?=
 =?utf-8?B?cVR1NXpWSWZKSTJYanFSWHdkVzFGQjl4b3lIVDBDUFJmYUhyYlk5KzJuMW83?=
 =?utf-8?B?dEpVRHNJQVlaa2Z0WkMxenNNc0dyQ2RLeC9obkhFQjF6dzdJV3Z1VXh3d0k2?=
 =?utf-8?B?TzZycFpReGtHYU1WcnBKUEw2NW1Fckw2SnBNNXVaZTNxa0gxMEVpMmZzZjk5?=
 =?utf-8?B?YXpJTVNEQ21NVjJTa2hQTjJCQ1FwV2NsZzkxOWNDNW0wbkgwV25aQ1Zmc1ZS?=
 =?utf-8?Q?BuOUgoBICp19tfsL7Lu2GfYcAwNGLCHcR2w7sm1?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e81272-0e0f-4be9-4e78-08d983dee0aa
X-MS-Exchange-CrossTenant-AuthSource: SG2PR02MB4108.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 06:52:33.3526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9k3VTEud40Xqcfev44KDZEU7jWLPXKP8AETatUXq7yh567kJCLnVGy0JYobqBtwxy199usIGjs6aUmd/dm9tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR02MB2382
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This patch can ensure that loop devices based on erofs and overlayfs 
can't set dio through __loop_update_dio.

Tested-by: Huang Jianan <huangjianan@oppo.com>

Thanks,
Jianan

在 2021/9/28 20:47, Chengguang Xu 写道:
> Loop device checks the ability of DIRECT-IO by checking
> a_ops->direct_IO of inode, in order to avoid this kind of
> false detection we set a_ops->direct_IO for overlayfs inode
> only when underlying inode really has DIRECT-IO ability.
>
> Reported-by: Huang Jianan <huangjianan@oppo.com>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>   fs/overlayfs/dir.c       |  2 ++
>   fs/overlayfs/inode.c     |  4 ++--
>   fs/overlayfs/overlayfs.h |  1 +
>   fs/overlayfs/util.c      | 14 ++++++++++++++
>   4 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 1fefb2b8960e..32a60f9e3f9e 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -648,6 +648,8 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
>   	/* Did we end up using the preallocated inode? */
>   	if (inode != d_inode(dentry))
>   		iput(inode);
> +	else
> +		ovl_inode_set_aops(inode);
>   
>   out_drop_write:
>   	ovl_drop_write(dentry);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 832b17589733..a7a327e4f790 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -659,7 +659,7 @@ static const struct inode_operations ovl_special_inode_operations = {
>   	.update_time	= ovl_update_time,
>   };
>   
> -static const struct address_space_operations ovl_aops = {
> +const struct address_space_operations ovl_aops = {
>   	/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
>   	.direct_IO		= noop_direct_IO,
>   };
> @@ -786,6 +786,7 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
>   	ovl_copyattr(realinode, inode);
>   	ovl_copyflags(realinode, inode);
>   	ovl_map_ino(inode, ino, fsid);
> +	ovl_inode_set_aops(inode);
>   }
>   
>   static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
> @@ -802,7 +803,6 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
>   	case S_IFREG:
>   		inode->i_op = &ovl_file_inode_operations;
>   		inode->i_fop = &ovl_file_operations;
> -		inode->i_mapping->a_ops = &ovl_aops;
>   		break;
>   
>   	case S_IFDIR:
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 3894f3347955..976c9d634293 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -349,6 +349,7 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry);
>   char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct dentry *dentry,
>   			     int padding);
>   int ovl_sync_status(struct ovl_fs *ofs);
> +void ovl_inode_set_aops(struct inode *inode);
>   
>   static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
>   {
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index f48284a2a896..33535dbee1c3 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -1060,3 +1060,17 @@ int ovl_sync_status(struct ovl_fs *ofs)
>   
>   	return errseq_check(&mnt->mnt_sb->s_wb_err, ofs->errseq);
>   }
> +
> +extern const struct address_space_operations ovl_aops;
> +void ovl_inode_set_aops(struct inode *inode)
> +{
> +	struct inode *realinode;
> +
> +	if (!S_ISREG(inode->i_mode))
> +		return;
> +
> +	realinode = ovl_inode_realdata(inode);
> +	if (realinode && realinode->i_mapping && realinode->i_mapping->a_ops &&
> +	    realinode->i_mapping->a_ops->direct_IO)
> +		inode->i_mapping->a_ops = &ovl_aops;
> +}

