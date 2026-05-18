Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013062.outbound.protection.outlook.com [52.101.83.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC9E3E4C7F;
	Mon, 18 May 2026 09:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779095064; cv=fail; b=IhV7Qi20KHsCXkvJpZbM3iXiCyI2jqKPUhRaCux86QnczDbY2etKx4C/MeGjG28gbdApMeQomJrpatPm9b/kwNyL7qZQbNBIYT7KH2AbQTKGk7hv+ieKrpYE5FwppTw5jmETmF+Kg5nBcradXVcAQAnkwo4PQLDX8XiV0hZpXBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779095064; c=relaxed/simple;
	bh=yi2Ix7w8HJ9pum8amCYEJwpppQnSqiodeCjauZn6gCI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=o7FJQU2fSXp8VdFiGKpLjZ5JcBS+CrHhH9ogtSEBh/jvr70JBg9NmpfoXIjO57UNCMxXWTTpUYqMnrJITNDWLQVQbbaZvB7gMeXhyMsyfCZLHvLD8VSPNWT6rms8ucuy/jCd2f836zuEv/NQlmQT1xtGZUPxfsaxWiUTg4y1Pd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=prevas.dk; spf=pass smtp.mailfrom=prevas.dk; dkim=pass (1024-bit key) header.d=prevas.dk header.i=@prevas.dk header.b=FknCz0Kh; arc=fail smtp.client-ip=52.101.83.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=prevas.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=prevas.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=prevas.dk header.i=@prevas.dk header.b="FknCz0Kh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OSjB+d0aYxU8BHsYV/EABUZerc8gaUgWxrTEEoZ1auTXrSH5blVwvknWEq1/wif/nd5yHFYP0R2JOlABI0VPbaRuuKvevyefWs5bjW9DiDiyzdSledFphtKPCXgqvslSVW+/kZi7lYKPK3hMMC8E+e7DqwUjVwnFt1qvvlwB1LnkEhKfbrid7Z46tW8LZOcOS+R1darMkbf+kI+SvlTuznMsn6BKVswVwC1eWPaKX8jrq6rQqnlonBPcPSyOu0RhZ5twgKjetu813fc3LkewBMx4yTkXHtVdyt5lB80r+8FSNUMNbea8ZN9WZeuE2BaJtAUrIIgph9DVHweOHyV97Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uzDnx4mp+ZJSp09dnNe7CtGat+nWh/LZ40xMyOsJ03c=;
 b=BHA6hCwbESJsQtldVEEIPrZdMFS8IOY4GnN55C81UAT0/+ygcs45NmXQMN0Sj6uR1+KhaGrLDWhx5C2ACtuld1l7ZUFDHkoGzSw1StqKDE9S8KZkmDJzWQe44G8CNSSr8uZmLKgNvVQVRNQUes3AvI4MA9Gg3xf0nzuF8uXAozJwdfU8BiullvtjJbGAq5MBo2Ctqjd/JKeKCZAeQEpINzSHrtK0s/G+zGHWPosAmDAJ1+Vu8D9Q73MkqpxPfQi4knTtJBeClyo8KN7CbWDHmBRdoKBK6ktBWO6RusX4PM8bN5Ek21wHJ8e3ulDyPqgtt9vYWbsbaLp/JFn4F5WMFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzDnx4mp+ZJSp09dnNe7CtGat+nWh/LZ40xMyOsJ03c=;
 b=FknCz0KhyGEE7UVUQJLe6p8FjzfX4wqTRgDdbg1MZng9cosyjEyrn8vTW7BVNKz28n/A4Zsb8HRa/1YjJgi5atW8mr1BI4IUhdtjES09UoooXBJIIQ47TApyVWxfcbFCSnxd5lwq5wT+1e6z/+VsnC7zhfaUtMw6GDCdK32/16w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prevas.dk;
Received: from AS5PR10MB8243.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:681::18)
 by VI0PR10MB9499.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:308::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Mon, 18 May
 2026 09:04:11 +0000
Received: from AS5PR10MB8243.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ebc6:4e0d:5d6b:95d8]) by AS5PR10MB8243.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ebc6:4e0d:5d6b:95d8%6]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 09:04:11 +0000
From: Rasmus Villemoes <ravi@prevas.dk>
To: Amir Goldstein <amir73il@gmail.com>
Cc: David Laight <david.laight.linux@gmail.com>,  Miklos Szeredi
 <miklos@szeredi.hu>,  Christian Brauner <brauner@kernel.org>,  Jan Kara
 <jack@suse.cz>,  Al Viro <viro@zeniv.linux.org.uk>,  Linus Torvalds
 <torvalds@linux-foundation.org>,  Nirmoy Das <nirmoyd@nvidia.com>,
  linux-unionfs@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
In-Reply-To: <CAOQ4uxjX=C6WZvW1DdJ13tJj-XBWVxgE2Q9vVvHoYqiOhqW0wQ@mail.gmail.com>
	(Amir Goldstein's message of "Sat, 16 May 2026 13:39:11 +0200")
References: <20260514200129.94862-1-amir73il@gmail.com>
	<20260515193010.056ef472@pumpkin>
	<CAOQ4uxjDeF3uDe=OTVZ3fK65dF148FRUvPx5fOqZpoFuGUsmJQ@mail.gmail.com>
	<20260516094242.77d20c92@pumpkin>
	<CAOQ4uxjX=C6WZvW1DdJ13tJj-XBWVxgE2Q9vVvHoYqiOhqW0wQ@mail.gmail.com>
Date: Mon, 18 May 2026 11:04:09 +0200
Message-ID: <87se7pdr7a.fsf@prevas.dk>
User-Agent: Gnus/5.13 (Gnus v5.13)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CPBP307CA0009.DNKP307.PROD.OUTLOOK.COM
 (2603:10a6:380:1::12) To AS5PR10MB8243.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:681::18)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS5PR10MB8243:EE_|VI0PR10MB9499:EE_
X-MS-Office365-Filtering-Correlation-Id: 9012b44b-00ba-4121-d7b3-08deb4bc6cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|52116014|1800799024|38350700014|11063799003|22082099003|56012099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	SbRdqIUFDEmNzGBDuOivOY3zhj4nHw5NoF3sR/glc27OrdJz9Y44pVMedFnEc5GbSNuyHbirNzDDUMpWBm2gcQXa3QehGvTomSyEeYCo/mnMqS9CeMJCO7SvrK+Nx5O1y+ZqFZt8PFP3rm0yVENkYyovP3tUQpgBrKUwBxpyQsGf7bKWs6qNPve9k6Q0l7blQpA549fK65doxDjcxwF420ap6K+7IEqVXUozvhYUF1uuQJQR3K8t5WTViZigEooymTIxCam1nWtCOD3Tldo7pRTR0H+3mCjubzpOCIHEB1v84Wimk5TnPKpUWmXkfgIGxYW3L4EATIjVtYMmv5OyELx9PmmYq6E7PnKmdpTr2x90fIVsfx7FFRf2A6zLJLpndeVue0oM94iKlc/K7MKp6R3WUEbHi9Vo8vVJ4AMVKSZzJGTLgY+NX/VB8gCgUobWRYQ1Vl5J3mV/eVP/ZTeNeV5x9oZpnQHqvIklTjxe2Z3TRMZc6IXl+Wc2Et60c2xx+da13LYicyJlhRLtzj+5KZ39BvGETSQZscKlJ/1uNvAZMKeCsMb8vqLxbBKtzhQYxDqxWeNZvT/NlD0/hEGx3UgsDvFl8mX/NZ5NOHfCmQXpytCKsYJaYLYnzjED/gVoPvjbUp7EPZeDu/ytrJFmeYWo8gh/as8CSt2Sg8xL/0ldbaZNRyA8DGJlQyIoG0LYqnKNOR6jzZx9rUfD02yo/KoeN/O2Ks2hojay3KTz8LA0zqJ7c+MX3Vea0R+7Kc/X
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS5PR10MB8243.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(52116014)(1800799024)(38350700014)(11063799003)(22082099003)(56012099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTBMeStZY3c2bFhSeVJxTFp2SmNyYmw2am9BTDFZUHpSTmIxQStnQy9tYVhO?=
 =?utf-8?B?dDFsRnVCNjAyT2s0djVWRGJaMXRKRFNlRnYzQzlmU3ZtTmQvNyt6dThQZWda?=
 =?utf-8?B?eHlxTW41ZVBYR0hwSjJtdmd5WE1aRTl5YlJCZUpLVlk3eXh0cGJCZS9lb2Fn?=
 =?utf-8?B?MThYUzJPK1REMTNEWGZxNlY3K25sbFZGc3ZGUlVWN2hxKzZjRTlSSDcvbnJs?=
 =?utf-8?B?dHFHWVRHejAwbXNoNU5HZW1aUmRDZWxkVkt2aHlONjlGeGx0enltUGhDeU4x?=
 =?utf-8?B?NjBzQjlZbWE4aHg3cFBEL3dQdXc5dlRacHdZZFVHNDd3VE9hWHYzeEdEd2Zi?=
 =?utf-8?B?MHdzdjNCdldtOTRtbWJGOVh1Sy9JM3JQR0xtNkhGZUxVNGJkNVVMV2E3cFNB?=
 =?utf-8?B?U1d3U0MzVy9wbGNKOUNTdEVTQWF2NFFCZFhseWorU1RZV2NRSXBCN2MxWnJK?=
 =?utf-8?B?VzcvUDlocDBBT2Q3MXVHMVlyK2dEVDNBUnAyckJrRUZzSzZmdldmeWRBaEFh?=
 =?utf-8?B?QzJWRmhqY3NIY01UOFN0emF6RTBuSGlmT0hnQWZaUmVKQ28wcXJrbzlXYzU4?=
 =?utf-8?B?N3dwZkxOREsybkJQWlZrOWxFeVBtWE9mVnBUVHA2NzB0ZXdUeEY3WnMzOHUv?=
 =?utf-8?B?bjlNUUdLcy81NjdHSk8xQXZ1Y05HQjFtVnVxSVlIUnk1YkF5UTVaelJyTW1H?=
 =?utf-8?B?MzB4dW9GUmdkSnJPTGFNSzNGZGo0bEdIM1BSRi9hbXFKQ0FCU045VFZ5OFNK?=
 =?utf-8?B?Yk9IT0ZQek1IaDk1VzQ3WHRtTGNBZXZlamkvOWhjQ3IrYk5jOTc0V21mVWVm?=
 =?utf-8?B?aWJDOG5jM2JsYWhIQWlYaEppODk2OWRBcC9BSHQwSkpCUjFadnhBQ1JNTkV0?=
 =?utf-8?B?aHpZZEQzZDdJL0Z5UmNUSjVPK1JaeWJJV1dvQlpOSnl0Rjh1WXVrbmE3MStj?=
 =?utf-8?B?ODhuNHZQdWhEOUMvV1REbVh6UmRvb1kvUFoyZG5obDRzYW04Zks1d1NnVVBl?=
 =?utf-8?B?UFlkZHcrc2ZGeU01bHB4SFdwRUlhRUpZb294ME92UEp1MUtMcVg2UmpnZitQ?=
 =?utf-8?B?STRFS2V2SzA3dkNGMW5URkdoRk5lbW9IUHNSRmh1RmVZMlRabjBXQ2FIUHA5?=
 =?utf-8?B?eDNsNStPOGJscEN0Q08rSnJzTzdRcUVYMFlqdzJsTHFuNGtDTWozUUx4R1Ri?=
 =?utf-8?B?NlUzUjZtQXlZSTNKemJHSVIvVFlNbWF4YUEyYnoxY056TkFOcHl6b2g3ZG5P?=
 =?utf-8?B?a3Z5ektjYU1ZUjd3WEU1U3pZbGNrNGZtakpVaG4yaVFzUVZKUmtCanZiVFRC?=
 =?utf-8?B?Y1pqcklQZTIzall6bFBUZ0dMU2NhWmxLNWN0SDBBQUo0WWYyKzcrNDVDb3I0?=
 =?utf-8?B?UUhZRHpmeXhRTVMwR3RjQU1QaU41b1I2aTBqaXM2WGxWSkd1b2tjWmRIL09Q?=
 =?utf-8?B?UXUybHJJSVhpTDVnVHdDMC9udHVqa2xlcXlYbmdrZy9UQlZKazMyZWtrM0wv?=
 =?utf-8?B?dGFVRUFjQ2VmVHNDQnptOXVnTjNjdklqaDU4UlFNMDlxS1VLRENlQjI4cjdT?=
 =?utf-8?B?Ukorb0Z0UDVjbCt0L1p6REhpbjFkRWtSNEkyWWI1WWE0Q2k1M3NGV1VnR1p0?=
 =?utf-8?B?OThnNGxhMm5oalpTVVlsOHNneENkL1hOVHNDVk1lOXUzWVlpYjArdDg0MnJT?=
 =?utf-8?B?VmpBQzA2QUxyZ2IwQWdUOXh6RjlONGJteFdIVXY1WW5UWFg2dXNDYzVxdDRa?=
 =?utf-8?B?NThKMVFqZ0RpbTVPdmVNdDZMbjZYRHFlMUp1RkJLeEM1N254UVJiQ25yZVJ6?=
 =?utf-8?B?bWtMNzN1Y3cxcVpPTS9sWlcvUUlBRmxPZUdhL2kvSnhJY1p2RWFhWFVsUVN1?=
 =?utf-8?B?Z0xUMjhlejhKQWF2ZHc0ZnRYU25qZHAzaWlQUXV5WGRtQjhWZ1ZKOTl2LzB5?=
 =?utf-8?B?RmN0b1RGOEllWVpaV2N2MGNSN3g2WFUxa0NWREtaQWtHNFRpMmdyN0JoWW9l?=
 =?utf-8?B?bzJ6VDQzc2VBVlExN1ZRRFkwS0pEcEtGRld5R2ZBR3QzYi84MmpCM3dZWUtQ?=
 =?utf-8?B?RytxZzFKdWZsWWNTUEpIRVVMSkNvNFUxcGRFVzBDa0VaS01hLzl0dEVia2Yz?=
 =?utf-8?B?YVNlbjZ1Mjkvcm44OFlPR0wyZUdwZXhWeVU4YjhvQ0tzOXU2UXpNWWQ2a3ll?=
 =?utf-8?B?Rmg4TVNEV3N4cDNqRUhuazFWbGlmeUdDQld3NXY1NnVEVW1WQjgxS2wzR01I?=
 =?utf-8?B?em4wdDNwaVJ5RTcvckM5U2NQNEY2MFd0QS9YT2w1ZzZPT2cwWWh0dC9zQ0sv?=
 =?utf-8?B?WUZWSnFKKzQ3UWg5QkVPRDZnNi96eDZ4SkYzNW1MTGlEQTN2TWwzb1FseCt3?=
 =?utf-8?Q?7c7WsJahpaOfGI3s=3D?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 9012b44b-00ba-4121-d7b3-08deb4bc6cf5
X-MS-Exchange-CrossTenant-AuthSource: AS5PR10MB8243.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 09:04:11.0714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +A2/R++4JUh/j8tApeW0qKhspwlV2rzURjzTcrOqY8vfd6vSGHTeM6TCdjw+0ce1vlwLqvcvvkQ3G4x0AIQq7BGh7Ss9VolBpQ3prx6HEmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR10MB9499

On Sat, May 16 2026, Amir Goldstein <amir73il@gmail.com> wrote:

> On Sat, May 16, 2026 at 10:42=E2=80=AFAM David Laight
> <david.laight.linux@gmail.com> wrote:
>>
>> On Fri, 15 May 2026 21:26:04 +0200
>> Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> > On Fri, May 15, 2026 at 8:30=E2=80=AFPM David Laight
>> > <david.laight.linux@gmail.com> wrote:
>> > >
>> > > On Thu, 14 May 2026 22:01:29 +0200
>> > > Amir Goldstein <amir73il@gmail.com> wrote:
>> > >
>> ...
>> > >
>> > > The object code bloat would be noticeable if this were used everywhe=
re.
>> > > But you could make it a bit simpler:
>> > >         if (__builtin_constant_p(__e))
>> > >                 BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));
>> > >         else if WARN_ON(__e && !IS_ERR_VALUE(__e))
>> > >                 __e =3D -MAX_ERRNO; // Or maybe -EINVAL to stop and =
other boundary errors
>> > >         (void *)__e;
>> >
>> > Yeh that's nicer thanks.
>>
>> Actually this might be better still (or just more succinct):
>>         void *__e =3D (void *)error;
>>         BUILD_BUG_ON(!statically_true(IS_ERR_OR_NULL(__e));
>
> This condition is wrong but also my compiler does not evaluate
> __builtin_constant_p(IS_ERR_OR_NULL(__e)) as true.
>
> This works
> BUILD_BUG_ON(statically_true(!IS_ERR_VALUE(__e)));
>
> I think it is enough to statically assert on ERR_PTR(EINVAL)
> and no need to bother with ERR_PTR(0)
>
>>         if (WARN_ON(!IS_ERR_OR_NULL(__e))
>>                 __e =3D (void *)-EINVAL;
>
> Oh, anything but EINVAL please - the most overloaded error value
> My choice of meaningful error value would be EFAULT

Could we have a dedicated "EBUG" that can be used to indicate "there's a
bug somewhere in the kernel, we can handle it somewhat gracefully here
by returning an error instead of BUG(). You can't do anything about it
but report that you got -EBUG from $this_syscall", instead of
overloading EIO, EFAULT, EINVAL or whatnot. Internally, EBUG could be a
macro that did ({ WARN_ONCE(); -__EBUG; }) or something, so there would
automatically be bread crumbs in dmesg if it is ever hit.

Userspace code could also benefit from having EBUG to indicate that some
internal inconsistency has been detected.

Rasmus
