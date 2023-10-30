Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A57EC4332F
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 04:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjJ3EQH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 00:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjJ3EQG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 00:16:06 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2109.outbound.protection.outlook.com [40.107.243.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431EAB4
        for <linux-unionfs@vger.kernel.org>; Sun, 29 Oct 2023 21:16:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOQEQSy9BvbUqD689tNrlp9seK01LR3XO88fKdML3fQdW97eF/IRyJYJWJFXhf5N8Z9hcIB5H5fLJJlB3aZKj9Nvuy8kRm3gA67XrKgdlvl5MZB0yGwe2L2V0n1QN+iVEMhogZCwnadlzenIZYc4lEr3rS+1H5uXDQLYGfTPEB3495ivjRjr1WU9++bk2tEJNl89ezbRemEtJaEmQMKawIJ9wVP1xWMXor48xzUZ0nwRfDRJYkg5000BpSRVeZx+IXlIwc+JmsieF0Kn4af696fAlzH00BlyTxw0c8x+FzR0itSLIqDHadfAQNowYohr6DRmAd/fq8r4LeJbUlKNrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q79GQduKt+0ddXNB+p1/fsADDE7MjmwzWRfjYmHpDsI=;
 b=jbTApFWjydE6x8sx9k0OuQJW9AIBKyj/40IUz1n5QS8cNxzQbPyDtR0YLYYRvNBlMPC/YMqI0jDGaySW+KsaRHDdIU+VAoaRdOaBOjAntBVJkGcZtraph0Vc69La38CQOPrYDJX7Xuvk6p1ElODk1Izj6rh7OUOk4k56ALO1ytKYO445SuNC5kYnIZ4QJ1dlpMrBQTHgHi5Oq9iNgHDagou0ObprDEvTYhiACKBJedd9f+pHOaLNbYi1QEMeyZ6gqalqj+tjPxIZ4l6J9BWRe3PyP8WRkHImORgXP3WCzOJ2+dJlls9xrkkjNTApaLsV1QWqMuMbTm/ghSDrng3ByQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=obsidian.systems; dmarc=pass action=none
 header.from=obsidian.systems; dkim=pass header.d=obsidian.systems; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=obsidiansystems.onmicrosoft.com;
 s=selector1-obsidiansystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q79GQduKt+0ddXNB+p1/fsADDE7MjmwzWRfjYmHpDsI=;
 b=No8ZNg+uQG3M3e7H/ZsdoLtRb4nJ1673RNda5xM8cFVQXpFKCXYjnDMJX8u2VkH89AcCXqqg3DswIYYF9kCDXt6fQpbwQxNt2LnjNidG7o9QlVwqCz5p+QIlwm2zsRSLVuPv1NGqrvSygFfB5Wau3oXkSPTyc1j+VetW6+sjoPY=
Received: from PH7PR14MB5569.namprd14.prod.outlook.com (2603:10b6:510:1fb::16)
 by CH2PR14MB3561.namprd14.prod.outlook.com (2603:10b6:610:6c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Mon, 30 Oct
 2023 04:15:57 +0000
Received: from PH7PR14MB5569.namprd14.prod.outlook.com
 ([fe80::f021:1e3d:f24:eaf8]) by PH7PR14MB5569.namprd14.prod.outlook.com
 ([fe80::f021:1e3d:f24:eaf8%5]) with mapi id 15.20.6933.026; Mon, 30 Oct 2023
 04:15:56 +0000
From:   John Ericson <john.ericson@obsidian.systems>
To:     "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
CC:     Amir Goldstein <amir73il@gmail.com>
Subject: Re: "Resetting" an overlay fs entry; clearing the upper layer and
 revealing the lower layer
Thread-Topic: "Resetting" an overlay fs entry; clearing the upper layer and
 revealing the lower layer
Thread-Index: AQHZuPyPVjqAOjROjky9Pum6cGQnI6/C2p7JgJ8xGIo=
Date:   Mon, 30 Oct 2023 04:15:55 +0000
Message-ID: <PH7PR14MB5569AA53E80797E88333DA5FF5A1A@PH7PR14MB5569.namprd14.prod.outlook.com>
References: <PH7PR14MB55699F84995FB1FBBEA5663BF53BA@PH7PR14MB5569.namprd14.prod.outlook.com>
 <PH7PR14MB55698C0C851B995C9E8C649AF53EA@PH7PR14MB5569.namprd14.prod.outlook.com>
In-Reply-To: <PH7PR14MB55698C0C851B995C9E8C649AF53EA@PH7PR14MB5569.namprd14.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=obsidian.systems;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR14MB5569:EE_|CH2PR14MB3561:EE_
x-ms-office365-filtering-correlation-id: a58f3cac-d70f-4ab8-f405-08dbd8fee9a5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wQD7YXbxJS792kCZeCvyX20EMxLfS0mP7Zs8fXE+xK3SsAqA06pB/O2xVMJwh15MhzKNYhOEQfc9pWCrfvqGlY0f0THaMaOqp9fbYdNHrGMLnb2T0jUd4N/DryAEnAKKXSXdhF+8S72jQ5zEZZB2DXW34dvs4HNViGyh3OphLIdw6I+LFQ/ciKfCQ4aIX/CBxqLKyZaKB52Dz9kM5+VyTurjRGQEVsUMypF+Cks8POlE7XfRzLMBE8+8zH7YsqSNCg/i9XQlcBQ7xTdjQ2JpBMqLQ9jf8Cf6/c6aB0c9OqCWO/RsPNgmtoRIBC9k498N2J43SyUBNeEVAVXRkIOUbnNK7apPo9r/9kVY3HwH0/umUxm5aTGfda14HnLwU/0eU4aHZt2W5tF6pS4K5E4Te5wFsUBXNY20VsZOoYx6+nwXfveqxJiHTU5R9IdmfJlHf1ZWg6jPASUwmGKAd42O2mGxhR5oIPIGInHzMNku4yjZJwoFiKR49ziB6OSPZTvoQ67Md2GDg2UOutjKT7SLjrW2A3aP7Xn8Ubm9EqIaetsGiI/cd45AH6RTi0BBn+j1ZsnJyZhKjVoABVa4lbX42gtMj+Jj3APoGqI3FtGO2Co=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR14MB5569.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39830400003)(346002)(366004)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(55016003)(9686003)(71200400001)(122000001)(7696005)(6506007)(38100700002)(478600001)(76116006)(66946007)(91956017)(83380400001)(53546011)(66476007)(66556008)(64756008)(66446008)(6916009)(316002)(52536014)(8936002)(4326008)(8676002)(5660300002)(33656002)(30864003)(2906002)(86362001)(41300700001)(38070700009)(44832011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?l7yAs31/YBeFlrXyam2rRz/oRHmwUFF/ah7NHRllxx9YVGk0CRgTzx8z39?=
 =?iso-8859-1?Q?woChHrOTJ2M8FVBU27ocEv+OOA7Z0rRbrAnu8+lHDFSsBKAvsvT4EWLyVe?=
 =?iso-8859-1?Q?+53714j1KDpM7730HQQTOdt9GfrZBm67C3j7oUJNtEIJ/Vn94QM2/171+x?=
 =?iso-8859-1?Q?8FAP8X5bT1sdF0dmdLbcCsC6Ny/qI+W7sYCiVjfgeoQLpm4roDUoJ0q1U/?=
 =?iso-8859-1?Q?kgZgxcsstGYV70SzgEFXcXN3+qqmnqNyuR0jkFkIk7Dj8p2guAQcK6PIz+?=
 =?iso-8859-1?Q?/yAn8tHzoWJ64d2HT+LprbYbyi08QlDEF3Hsw680HlB7Fw7njBXRyJsIiL?=
 =?iso-8859-1?Q?OWg0dviVL99igUCU6DzzxXsb+p3YhsKn0k0jqSzW6Vz2X29xfuNzBFAeqy?=
 =?iso-8859-1?Q?r/nQIE3Hmvs7HC/bYJxXT2pAKz/iwwbGShDTYTEuMVIbfCE9/qCKhcY7+m?=
 =?iso-8859-1?Q?Y8gYfhIbpukHYljh88JcGjcmswHIl1g+6BG5fxVbUt1hXS2cerYdoamL+2?=
 =?iso-8859-1?Q?xB5sIz1aCwCfKKxNZU5hsn1lQ6tDNL4dHhErcDx4nKvl2dHuPag/jiNv7l?=
 =?iso-8859-1?Q?Rf+h7K9PQYxWnASvpmTv8drVhrZM3J5bdH38le1bBWcX5LuYRlWJ47Dy1P?=
 =?iso-8859-1?Q?2iokSoV/NPeuVbjs6QYqiSS0tn5bEwDjza3J/GM9HSOyue/7NJC1enhyj8?=
 =?iso-8859-1?Q?/jozlloe0bGWJICA0rvMZ/Esr3+T3BDECsv0NQ3VtCdYetuUwV9G/GkAi/?=
 =?iso-8859-1?Q?ENqcXjAE8XcO5p9Zf8TWKhiiU5fQ2mEVYDwGBK8LItBkqNOLgNhqB8tDWc?=
 =?iso-8859-1?Q?Fi6sh/opZiWzw1rH56l7jBtExqZ4EcNqeUA1IcgHveJwbTRFAGqLC0JjYu?=
 =?iso-8859-1?Q?lr6N3URWkJTAHJaoW1QjRfhZiYwNY9SEVV60NtNPlylJFn9Y2M8moXgET6?=
 =?iso-8859-1?Q?ODLiPPVh4+fjHRVhxBhkO1wPDjgOkyf6stDLEnwFE6RxbPEweVB4UChIf/?=
 =?iso-8859-1?Q?uKQnHO4hPOgsGFVx37X/+wPF8CRUkmfTX8gwgVDubud8uL3usUgKITk3i1?=
 =?iso-8859-1?Q?FyQ/PWP2aYPs1zJa8N6mELBmzIEW0oLL+W1gSQ/XecqCiA2hr4Mn4KlYxd?=
 =?iso-8859-1?Q?hIATsyZGqzXUu8egL24GQ279Y5cR7nhbeqf+80WEdDxzAEx+sQ6TcatUnL?=
 =?iso-8859-1?Q?NJtROZdRxzb1nGLoQ0s47VcnIubNtZI8V8qPEvhXohC41OpAyYtiDvLYo1?=
 =?iso-8859-1?Q?6MugKTMdPrTqHCQd17xCfsBYNzDXp6GIoLaf+dM+4Dl3B6w/9ZC9iIvrMY?=
 =?iso-8859-1?Q?fbvuE18D7p+9CFc8zM1rrCbI+9IlpLbbSyVsU1IWcUVvJZgdsSK/eFrJGr?=
 =?iso-8859-1?Q?c6rCoa0L7FAUcckC77BhqL2lyc0k59uaVZkF5/k/2fjZs14AIxOoNYetUp?=
 =?iso-8859-1?Q?+LpBs4OzDCXHlkh2E2Gipg9crvrsf38zlpFo0p35Qr4+fwiZUHSCYYdFi9?=
 =?iso-8859-1?Q?NsqoOETL4olA0BLn/kQxGRqQ2Xm0MVkbP81KpmpQiI0E8rceLzlO0y27E3?=
 =?iso-8859-1?Q?3ZhthxXx+0O2rSotY81hDyqytIDAEdnnd4RtFTRJaxFvNWi+GO8H7UNPBh?=
 =?iso-8859-1?Q?lG8kS4+6NYKtZ/vUCFWBzig/9bS93TiXPRAhYRqefhwfR0EOSeCZ66p8Vf?=
 =?iso-8859-1?Q?pO6z4Y1SW1u6M18gnA2VsqY7sXnNBR3gCoozovAaDiiOrjOlIAy/IvHT16?=
 =?iso-8859-1?Q?ekNQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: obsidian.systems
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR14MB5569.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a58f3cac-d70f-4ab8-f405-08dbd8fee9a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2023 04:15:55.5996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9e4fbd9c-5fe9-457b-906b-5ad50664f878
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K7qQwl/w+bVO/gXL4ueRVF521izicFfWYoVu8fWqXRkbtfKKdTRsuTxQJlVVUNBIS13j1lxGHtLKTa5+LLUT6Ws5ObfAFg5zVk/PLRme1oQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR14MB3561
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

We aren't working on this at the moment, but I did have some off-list discu=
ss discussion with Amir Goldstein. I wanted to include our correspondence o=
n this list for posterity --- e.g. us working on this later, someone else w=
orking on this later, etc., and he said that is fine, so here it is. It too=
k me a while to find the time splice together all the replies and their quo=
tes, but now I have it.=0A=
=0A=
One thing I'll add is that while I still think this "resetting" operation i=
s a good feature for overlay fs in general (and not just our use-case), the=
 FUSE passthrough work (from Android most recently, not yet merged AFIAK) w=
ould be an even better fit for our use-case than overlay fs. I don't know i=
f upstreaming that is still being pursued, but if it is, it seams reasonabl=
e to just wait for it. Indeed, FUSE passthrough ought to be a good replacem=
ent for the whole gamut of exotic bind/union/overlay mounting without out a=
dding endless more functionality and code to the kernel.=0A=
=0A=
Cheers,=0A=
=0A=
John=0A=
=0A=
> On Mon, Jul 24, 2023, 9:29 PM John Ericson <john.ericson@obsidian.systems=
> wrote:=0A=
>> On 7/24/23 03:51, Amir Goldstein wrote:=0A=
>>> On Sun, Jul 23, 2023, 6:38 PM John Ericson =0A=
>>>> Thanks for this information, Amir. It's very useful.=0A=
>>>> =0A=
>>>> On Thu, Jul 20, 2023, at 8:51 PM, Amir Goldstein wrote:=0A=
>>>>> Hi=0A=
>>>>> =0A=
>>>>> Writing offlist because I'm on mobile =0A=
>>>>> The problem is hard and you are not the first one to ask about it - n=
eed to narrow it down to exact requirements to be able to solve it. =0A=
>>>> Yes, not surprised others have asked about this. If you can point me t=
o the previous times it has been discussed (which I failed to find before),=
 I am happy to read that correspondence rather than ask questions which may=
 already be answered :).=0A=
>>> Afaik it never got passed "we want to do that"... "It's complicated " m=
aybe you'll be the first ;)=0A=
>> OK :)=0A=
>>>> Also, if there was something describing the overall approach of the in=
-memory data structures, (https://docs.kernel.org/filesystems/overlayfs.htm=
l is more user focused, though one can get an inkling of what might be goin=
g on from squinting at it), that would be tremendously useful. (Based on th=
e rest of your comments, I think this is the main thing I am missing.)=0A=
>>>>> On Thu, Jul 20, 2023, 7:37 PM John Ericson <john.ericson@obsidian.sys=
tems> wrote:=0A=
>>>>>> We would like to be able to "reset" an overlay-fs directory entry, i=
.e.=0A=
>>>>>> remove whatever might exist for this entry in the upper layer and re=
vert=0A=
>>>>>> back to whatever is in lower layer. This operation would be akin to =
a=0A=
>>>>>> regular removal, except without creating whiteouts to cover up anyth=
ing=0A=
>>>>>> in the lower layer.=0A=
>>>>> =0A=
>>>>> Do you actually need to get rid of the upper entry or is it ok to jus=
t reset the upper entry to the metadata of the lower entry and make it a tr=
ansparent "metacopy" ?=0A=
>>>> Today we are modifying the upper layer and then remounting. This has t=
he semantics we want, but of course side-steps these issues by rebuilding t=
he in-memory data overlayfs data structures from scratch (I presume). I am =
basically open to whatever approach is=0A=
>>>> easiest that roughly corresponds to those semantics; not trying to put=
 the cart before the horse here demanding extra requirements when I do not =
know the details of the current implementation well :).=0A=
>>> No documentation that I know of. Vfs is not very well documented.=0A=
>> Gotcha. Well, at least good to know I wasn't missing something.=0A=
>>>>> What if lower entry does not exist?=0A=
>>>> So not sure how you envisioned this API.=0A=
>>>>> What if upper was renamed after copy up? And then=0A=
>>>> For what it is worth, we are not using redict_dir or the inode index. =
I am afraid I do not understand the significance of renaming outside extens=
ions like those. I can imagine renames/hardlinks can cause inodes to be reu=
sed across layers in perhaps-surprising=0A=
>>>> ways , but I didn't think overlay fs would care about this much.=0A=
>>>>> What if lower entry is another file or even a directory with same nam=
e? =0A=
>>>> It should be exposed regardless. I was hoping this would still be an O=
(1) changing some references in the in-memory VFS data structures, but if i=
t is O(n) because the overlayfs has a its own separate copies to a greater =
degree than I thought, I could see that=0A=
>>>> being a problem.=0A=
>>> So not sure how you envisioned this API.=0A=
>> My interpretation of your idea was similar to `unlinkat`, basically:=0A=
>> =0A=
>>     int overlayfs_reset_at(int overlay_dirfd, int lower_dirfd, const cha=
r pathname, int flags);=0A=
>> =0A=
>> The idea is that the path is relative *both* directory file descriptors.=
 If the path has a /, and *both subdirs exist*, this:=0A=
>> =0A=
>>     overlayfs_reset_at(foo, bar, "asdf/qwer", AT_REMOVEDIR);=0A=
>> =0A=
>> =0A=
>> is shorthand for:=0A=
>> =0A=
>>     overlayfs_reset_at(openat(foo, "asdf", O_PATH), openat(bar, "asdf", =
O_PATH), "qwer", AT_REMOVEDIR);=0A=
>> =0A=
>> the interesting case is if both subdirs do not exist:=0A=
>> =0A=
>>  1. If the lower one doesn't exist, it means the entry in question is wi=
thin an upper-/overly-only directory. We cannot reset the entry because the=
 overlay/upper parent directory (and possibly some ancestors also) is itsel=
f covering it up. The operation can fail in this case, or we can just defau=
lt to doing a plain old removal instead.=0A=
>>  2. If the overlay/upper one doesn't exist, it means their must be a fil=
e that is covering up an ancestor directory in the directory in the lower l=
ayer. The operation fails.=0A=
>> So the only case where the operation succeeds with a bonafide reset is w=
hen we can "cinch up" to both (immediate) parent directories. And to implem=
ent the permission check we just need check the read+execute permissions on=
 the lower one. (Conversely, I *don't* think it matters what the permission=
s on the target of the entry revealed by the restore is, because those will=
 be carried through to the (modified) overlayfs and respected. It is just t=
he existence of the entry which we are guarding against leaking.=0A=
>> =0A=
>> All that said, to go back and walk through your scenario=0A=
>> =0A=
>>> After rename, the target is covering no entry and the source is a white=
out.=0A=
>> Great, my understanding matches that.=0A=
>>> You cannot open "the whiteout" for ioctl so you would not be able to un=
cover the lower original file with the suggested ioctl method.=0A=
>>> Same goes for "undoing a delete".=0A=
>> You should not need to ever open a whiteout, but just the directory that=
 contains the whiteout.=0A=
>>> In this case maybe using link() with a special sort of tmpfile and usin=
g an ioctl with lower real fd as an input argument to overlayfs as a way to=
 get a special sort of lower tmpfile to link in place of the whiteout entry=
.=0A=
>> If we are just opening the directories, I don't think these extra hoops =
are needed? Or am I missing something?=0A=
> =0A=
> All I can say is it looks like a very big maybe.=0A=
> I can't see big flaws right now, but I think there are more details to fi=
nd out yet =0A=
> =0A=
> Also with all the special cases that are not handled you will need to arg=
ue your case that the limited functionally is useful for an interesting use=
 case.=0A=
> =0A=
>>>>>> As far as our team could discern, the kernel currently does not supp=
ort=0A=
>>>>>> this operation. Thus, we are considering what would be necessary to=
=0A=
>>>>>> implement this ourselves. Our initial exploration led us to=0A=
>>>>>> `ovl_do_remove` within `fs/overlayfs/dir.c` and in particular this=
=0A=
>>>>>> conditional:=0A=
>>>>>> =0A=
>>>>>>      if (!lower_positive)=0A=
>>>>>>          err =3D ovl_remove_upper(dentry, is_dir, &list);=0A=
>>>>>>      else=0A=
>>>>>>          err =3D ovl_remove_and_whiteout(dentry, &list);=0A=
>>>>>> =0A=
>>>>>> That seemed like a good place to begin --- if one were to force the=
=0A=
>>>>>> first case no new whiteouts would be created, correct?=0A=
>>>>> =0A=
>>>>> I don't think remove is the right way.=0A=
>>>>> Hard for me to explain why.=0A=
>>>>> The implementation would be more complicated than this if every to me=
tacopynis not enough and there is no good reference code for doing somethin=
g like this. =0A=
>>>> Fair enough. Yes, it is not at all clear what the ramifications of *no=
t* doing a whiteout here are; I wouldn't want to make the underlying layers=
 out of sync with the VFS!=0A=
>>> The easiest case is to "punch out" the modified data using an ioctl. It=
 does not cover undoing a delete or rename.=0A=
>> Hmm, I am not sure I follow. Do you mean evict the information on this p=
art of the from the VFS so it must be rebuilt on demand from the underlying=
 layers? If so, that sounds very promising; much nicer to do that and let t=
hings be rebuilt on demand by existing code.=0A=
>>>>> =0A=
>>>>>> Assuming that is indeed the right place to start, I have two follow-=
up=0A=
>>>>>> questions.=0A=
>>>>>> =0A=
>>>>>> 1. Since the desired end result of the operation is strictly closer =
to=0A=
>>>>>> the lower layer, should we possibly eliminate some of the other=0A=
>>>>>> operations in a fresh copy of this function? For instance, might=0A=
>>>>>> `ovl_copy_up` be unnecessary because if the upper layer already does=
n't=0A=
>>>>>> "contribute" to this dir entry, no action would need to be taken?=0A=
>>>>>> Additionally, what is the significance of `nlink`? We have not found=
=0A=
>>>>>> much documentation for it; from what we understand, it's an `xattr` =
used=0A=
>>>>>> so some information for the overlay-fs is persisted on disk.=0A=
>>>>> =0A=
>>>>> Hard to explain - if you keep upper metacopy and punch our the data a=
ll of the above is not relevant.=0A=
>>>>> =0A=
>>>>>> 2. What is the recommended approach to expose this functionality? We=
=0A=
>>>>>> assume it would be through a new `ioctl`, but with no existing=0A=
>>>>>> overlay-fs-specific `ioctl` as a reference, we are unsure if that wo=
uld=0A=
>>>>>> be the correct choice. We presume there are best practices on this=
=0A=
>>>>>> matter that we are not currently aware of.=0A=
>>>>> =0A=
>>>>> Not sure. I think there was an ioctl for getflags and it was remove. =
You can look at git history.=0A=
>>>> Thanks, I see it was removed in c4fe8aef2f07c8a41169bcb2c925f6a3a6818c=
a3. I can work from that. (However, I'll set this question aside until I kn=
ow more about the fundamentals of what we would be doing.)=0A=
>>>>>> Our intention is to upstream this patch if we write it. It would be=
=0A=
>>>>>> therefore beneficial to discuss any objections or concerns beforehan=
d.=0A=
>>>>>> For instance, one possible issue could be overlay-fs usage which=0A=
>>>>>> presumes that covered up lower layer data is private and inaccessibl=
e.=0A=
>>>>>> To make it possible to preserve that invariant, permissions for this=
=0A=
>>>>>> operation would have to be distinct from write permissions. This con=
cern=0A=
>>>>>> can thus be addressed, but it would increase the scope of the patch.=
=0A=
>>>>> =0A=
>>>>> I think it is best if the API can prove user has access to lower obje=
ct (do you have direct access to lower layer?) If ioctl passes open fd of t=
he lower object that caller can read from, it can be used as a proof that t=
here is no security concern with exposing the lower entry data because same=
 user can rewrite the same data.=0A=
>>>> Oh this is very elegant. Great idea!=0A=
>>> Good luck.=0A=
>> Thanks, we'll need it=
