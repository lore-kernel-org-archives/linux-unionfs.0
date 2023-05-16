Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D39AC77B7D
	for <linux-unionfs@archiver.kernel.org>; Tue, 16 May 2023 02:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjEPCNU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 15 May 2023 22:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjEPCNS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 May 2023 22:13:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34FD4231
        for <linux-unionfs@vger.kernel.org>; Mon, 15 May 2023 19:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684203191; x=1715739191;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=WrPFPSL9XnWFwoG3v6eBF2bD65C9FJs/9vmQGQKACQg=;
  b=iCX1hgTZpF2asM8B0k6KAJ/cyESCBc4SmqRIgGO+DgfEeB0NHACYlKdb
   gMvJVvXh4d0RI38i09EsUw+xAjkvgaP7eIS83Zjin1hKjO7lelywGPaaI
   hQ0gMQKFfrfmoNEqY87MQIO7JCvF5J0e9/Y8nGsvQSEj8SpK5/FZughl7
   wkREu4djmOuRlkJ9mGZJpBogHdG7figtRk2PpO+1q7ExwCUj4OlrlgqDO
   gi2UPeT4vBtm7eBBYZoQZ77Aifr1q+Vq61qXk/XQktSM9CChjUzyAfSxY
   Oc5jpPfPMMpfB2dXmVPFCYbG2OslHPJUGCjRCUt40YNAizazjdzLdMqOV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="348859067"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="348859067"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 19:13:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="947649528"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="947649528"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 15 May 2023 19:13:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 19:13:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 19:13:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 19:13:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTHkoz5MBs4mEdm7k+Cn1qKguzCCdUFB1GePnhBgcDqpTPYuU2mxW8PjfzwVA2FN7xamIfptuBUx/0HW28oclZiQ0V0ksqUsns02W1bfTH+rpOtO9W6TLcBXOrWcUc3GLmjCopB1lArOi9TyNO236hNj7NubAx1CkETcxVWcxQz/8UL5eoaCrBR9D6iFB4+YBhT5IK8Ts5T4DVSi7K85TwMq1tuAx4/ZVwZYoWIaIEv2z4Ww8c2izqoB7ee8n7NCPR7pKi0fisYBqRuHgbxFMNSUqp0ecTGn7WGTjto2aYxSYs52kEEgKXf8cISoj1ORkd3K8Nya41qFgFmUPn1MKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vw03CWW2iSXqGW/qVxptY3279ECmUa3fTBI17cba1T8=;
 b=ZDKzwC0loR0fER+ZhsLTUMVt0uHJFvKMFfrAXNWk/8W/riYHzBkhU8j/HWC7Ws4siqwO/r39Qi/uoxJMX6QrnEUwtgXIR7XK7IL8IYQBonwzn7gkdt+JwyXFvK73AO9k0crciCpw2X02f9vLDbudam+tXa0FHvnIt52izUD3LpJAbX7IPrNiPy8+OoyZ0MmhIw4KWZblJeqHSI5QNe6tbx92nyd44dxJm67qNZ32BMwGs79fjeK8G00apcyUBdKgaqSeHQ4+GQJsrF9fzKAxsxLTqEpop/Pg4415AjBShJ0ZD/JyWPosLgs2fsAj6YwcZT9WlGHLsD5vgRR3uYZs+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by PH0PR11MB7635.namprd11.prod.outlook.com (2603:10b6:510:28e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 02:13:08 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf%6]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 02:13:08 +0000
Date:   Tue, 16 May 2023 10:13:00 +0800
From:   Oliver Sang <oliver.sang@intel.com>
To:     Amir Goldstein <amir73il@gmail.com>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        <oliver.sang@intel.com>
Subject: Re: [amir73il:ovl-lazy-lowerdata] [ovl] 1edcaf2012:
 BUG:KASAN:slab-out-of-bounds_in_ovl_get_lowerstack
Message-ID: <ZGLmrIzaDy7aHDyg@xsang-OptiPlex-9020>
References: <202305142217.46508384-oliver.sang@intel.com>
 <CAOQ4uxhM+_FbByg5168ReO48k9HAoaeL7xdLhq-n=rY7_iJAQQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhM+_FbByg5168ReO48k9HAoaeL7xdLhq-n=rY7_iJAQQ@mail.gmail.com>
X-ClientProxiedBy: SG2P153CA0021.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::8)
 To PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|PH0PR11MB7635:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fc3c133-a747-42fa-1c42-08db55b3174b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O+el0Usd30TTLxJNFLESxowUN2hKDlCFK9OADy3NWFWvPQd7sn3wYOgLA2Rlkp7hqHEzLbdmOAKQMZFSRxDpepHBIOwr8Z5NEjqo3mtTpK1VwlFh5z5RVR2BsebaNrn7kHw5N8hx97mLtRtOcGzNSPGW7OA99iJBUxrBVaBiB4OfuC5+CrXPK1eyQfehwNbah7pt2y7ZB/A/HRu08JOqUGIoGWYYPdkD3iIdZdME8iULyv6f+jW7ntDSi45fOSLNTh7nNlbmEJS0Twgq6OKi0MrKR/z8gkwyaTy4Pie0tU8tEDisT6qJgvROAAr4EWU4CL556J71ckerDs6RStIKmiVqhU+0XXRGexNRezBMtfHhktJDTA6M6dSVqN7BH46+o6GF1U/4kAhpD5aQ+j6u+HdkxVVZ2I6ky+eIDaBgFIcDmkB6mFMQkpCg9ly08cjMzxaOqVvFqoBZuZPPOS7q1CW2iDgmx7X8VVDWxf1WsYOGX7+x2fv6HJP/Okyykyv7H2trHej4VXHpXM1T32Dtz3S8NzdLJOuAWWwZU6oy2YBavUS56qhOMnYGe0M6voDOaBp5wNVuBNXEWEZc7j9lkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199021)(966005)(4326008)(66946007)(66556008)(66476007)(478600001)(6916009)(6486002)(86362001)(316002)(83380400001)(26005)(53546011)(186003)(107886003)(6512007)(9686003)(6506007)(5660300002)(8936002)(8676002)(44832011)(6666004)(2906002)(33716001)(82960400001)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlZmalF0d2syTHZBbjJLTTJsc0d0ZmRrdE54cTRLWGFhUUp3TDhTSE9tTjhq?=
 =?utf-8?B?alVoWUlVVFhoYyttelMwZFd0N0pmT1hyRkhsZkl5TDRacXpseWkxc2hVNk4y?=
 =?utf-8?B?SUZ0UXkva3lHRWFJdWtic1BPN1VMOHJMcy9jaE1KUVY5ekZidnhDYmRBd3Zw?=
 =?utf-8?B?QzBuc1c1YUdGZTVhbGNxc0Z1Qnl6a05YVmRGc09PWEJYVjN4QTJPZStCWDUz?=
 =?utf-8?B?Zk9kL0REM3IyNmlFS096ajNubE5xL1prZXNzZSt4dTN2OXYwTGpBbURWM0V6?=
 =?utf-8?B?a0plWUtlQi9saEUxVW9lK2psR2J3NitueFFaeEdSN0VEL3BON1dIa1ErRGg0?=
 =?utf-8?B?KzJUQ2VKMHF6bzNrazNjaWVtTXdXSWtlMHVHcTVQTmlQbHBKWEtjbTFldmFl?=
 =?utf-8?B?ZWxXYS9NbHlhRFBEOUJjQVRTL3Z0U2hYdjA0MFZhcSs3bEliMEV5amNramNw?=
 =?utf-8?B?V25uOVkwMnFNcUhWVG1WYWhqMlVjeExPRHNRRHlVc2JxSTZPWlVMUjFGUko4?=
 =?utf-8?B?RzFNbStXOHpCTWR1WmtvbGdNSjc3QTh2WFpCUXRJWk5OdDU4aWpGNWpTQUgz?=
 =?utf-8?B?ZmJTdkIzYjNPTUtjcXRocFZSSG9iR3VSTjBHZ3E3TVh0NE9PNnR1ajB3c0la?=
 =?utf-8?B?Vm5VMEc5SDFDVEQ0d1hNbEZobXVmTGdOREk1UE5peUxJbzF1S3RFV3hyRmll?=
 =?utf-8?B?cUxzeTlnazBqN1BHU2dJRDEvR0doTjFsTGRld2JRNS9aNnpuWEk3K09EM2Vo?=
 =?utf-8?B?dXczVlUrU0Rxd0pid1I2TWhiL3pzRDRLQjNmNUJKS3VwR2JJRnJvYVNBUGZF?=
 =?utf-8?B?bks2VXdBbXJ5NmRIU3hRVUhWc1NteGhXd1BtQW1ZL1l4OUZsdWFmRXErcDdq?=
 =?utf-8?B?L1ZhQ01rRkNBd1lzL0xFeUVQRVhzTEpFM25JOXprZGxnaDd2bHN4NVhxODhP?=
 =?utf-8?B?MHJQNHZhOXJERkJ4T3hJbnBxYmsveVQzb1FWVkpaSHB3L21vdDZjSWozT2NB?=
 =?utf-8?B?eEVWUjVqQmlQcXErV3U2endPWTN1czNRS3ZpNGxpWGpJZys2NUNYaHNJRUpM?=
 =?utf-8?B?Zk5DWHI1UXpkaUR6b0FzMXRlU3oya2pqRWxGTTB0YjhTZW56ZmNuV3dtMCs1?=
 =?utf-8?B?OWM4RjdxRG5ZQm5TbjNTblNkbjdzcWc3aGhleUVSWDBYN2luU2cwb1dMZXRX?=
 =?utf-8?B?RkVhcmtrSVRFbEJCdnJCNEZ3SGI0QldPcjFLenlWdUJDdlFHd1BPNng0dnNQ?=
 =?utf-8?B?d0NSSjZzQTBVNGpTR0VSd2ZwZzJSK1ZCck43dTlkcTkzaXZ4U2NvdTl6MDY2?=
 =?utf-8?B?SDltbG0zZjZlSVhyR0xrMXlHNjdIc3F6M01rL2g1dmhWMXYyb2FZSmRvSG01?=
 =?utf-8?B?a1hPaVJIQnMwVENPTW5SOXNRSkd1ZmpqcGw1OEovUS92Q3ZMK3F6WTNLeTN0?=
 =?utf-8?B?djc3Ynlra3dFdUptMW1HVnhuWmUyazhvVXM5cjVNTG9VOE5FNHlqWmdsOUFG?=
 =?utf-8?B?T0o1OU5WSlV5dzNOV0pTY2ZTVFpsVkpaU0N5RkU1U1Z5cmVYL2QybkRZYmZ5?=
 =?utf-8?B?M1RkSHYvQ2VZQXpIYlp3T1hoZTcyOUZZclpOdXdJanlVOHdlTUhOMnZZdWRT?=
 =?utf-8?B?UDZwdFRUU21IekRVNnRjenRDRjB3VXdRVzVwdUFWeDlxUmw5OElrM0ZjNk4r?=
 =?utf-8?B?bW9CclA5Vy9ON0ZId0pKV1l4STB2L01TVUhEY0loRWNZSUY0UUFaaEtaR3F3?=
 =?utf-8?B?VStsSkFqcjFIL1g2VUtqWGRBS3FVYmttNnd1T0dmYVZJOFJXbW51a1BrY200?=
 =?utf-8?B?aG9aRFQrTGw4UUFXWVJqNU5OMGVXdzdZdFNRWGdjUUlMN2JrS3U4Z2E1OG9m?=
 =?utf-8?B?NUJHcGwzRTlEQ254dlcwdzhxS1ZoQ0theTR3RkFFMVZCMGY5VmlUTVUxeHhv?=
 =?utf-8?B?Y05RTjJieU0rNGlkTHR4VzBZRDkxamo2RkRGM0dJZDVDSUFpam5YWUYzUDNq?=
 =?utf-8?B?aURnSnBPS3BKUE5nWHpPSGdpYmtvNVFhbFM5NndYUkNEN1R5MHpKTE1zaTE3?=
 =?utf-8?B?MEpCSGVJUHpUaFdTOS8reG1DZHlCczR5am9IRFBaMnVLVFdwcDJDZkpTaXhj?=
 =?utf-8?B?cmFjb1V4WFp1cmw2aVp3cjN2OWFMU1hyMnZaWGxNcE5HdGZvMm1oek84LzlD?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc3c133-a747-42fa-1c42-08db55b3174b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 02:13:08.5866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cw9faIyKcXAaiI/NUgeJi107ElDG/RI0xHGGbfGDSctZnoAfP+R7EhakR1Bc5TEO7lfjPhbKTo0kg2mWMrea1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7635
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Amir,

On Sun, May 14, 2023 at 10:17:05PM +0300, Amir Goldstein wrote:
> On Sun, May 14, 2023 at 6:30 PM kernel test robot <oliver.sang@intel.com> wrote:
> >
> >
> > Hello,
> >
> > kernel test robot noticed "BUG:KASAN:slab-out-of-bounds_in_ovl_get_lowerstack" on:
> >
> > commit: 1edcaf2012c0645e99125ebae675aa4d73e79880 ("ovl: introduce data-only lower layers")
> > https://github.com/amir73il/linux ovl-lazy-lowerdata
> >
> > in testcase: xfstests
> > version: xfstests-x86_64-06c027a-1_20230501
> > with following parameters:
> >
> >         disk: 4HDD
> >         fs: f2fs
> >         test: generic-group-63
> >
> >
> >
> > compiler: gcc-11
> > test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 16G memory
> >
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> >
> >
> >
> > If you fix the issue, kindly add following tag
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Link: https://lore.kernel.org/oe-lkp/202305142217.46508384-oliver.sang@intel.com
> >
> >
> > [   65.266308][ T2205] ==================================================================
> > [   65.274214][ T2205] BUG: KASAN: slab-out-of-bounds in ovl_get_lowerstack+0x68e/0x890 [overlay]
> > [   65.282812][ T2205] Read of size 1 at addr ffff8881109471ab by task mount/2205
> > ...
> > [   65.741460][ T2205]  ffff888110947200: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> > [   65.749334][ T2205]  ffff888110947280: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> > [   65.757202][ T2205] ==================================================================
> > [   65.765127][ T2205] Disabling lock debugging due to kernel taint
> >
> >
> 
> Thanks for the report.
> 
> I pushed a fix to branch ovl-lazy-lowerdata.
> I did not add Reported-by because it does not make sense when the
> bug in not upstream.
> If you test the new branch I can add Tested-by.
> 

I tested upon the tip of branch ovl-lazy-lowerdata
c4baed2e64e76 (amir73il/ovl-lazy-lowerdata) ovl: implement lazy lookup of lowerdata in data-only layers

and confirmed the issue gone. Thanks a lot!

Tested-by: kernel test robot <oliver.sang@intel.com>

> Thanks,
> Amir.
> 
