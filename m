Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29ABEB64D7
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 13:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjFPNO0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 09:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345435AbjFPNOZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 09:14:25 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC223592
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 06:14:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VlGJdN7_1686921257;
Received: from 192.168.33.9(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VlGJdN7_1686921257)
          by smtp.aliyun-inc.com;
          Fri, 16 Jun 2023 21:14:19 +0800
Message-ID: <f177a721-d137-424d-2fc5-adc149ea4766@linux.alibaba.com>
Date:   Fri, 16 Jun 2023 21:14:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2 5/6] ovl: Validate verity xattr when resolving
 lowerdata
To:     Alexander Larsson <alexl@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
References: <cover.1683102959.git.alexl@redhat.com>
 <CAOQ4uxhEq8u37YNnqQmLbybJy1Kkg3Qk0TVtRZQP-yHt8CMmWA@mail.gmail.com>
 <CAL7ro1Hqc29w-FuRuoEfcsxiXTnqqwHP73nwvmZRuKVRsz4D9w@mail.gmail.com>
 <CAOQ4uxh_y+YO3q7dB=ALCriq31RhapOHGt+jcXTQbOC7iVqYTw@mail.gmail.com>
 <CAL7ro1GTzJy5Nv1vH0buVEXUnUk7cXBhSJB2ap8Jt_hutk7nYw@mail.gmail.com>
 <CAOQ4uxgbMD2RdEqta7a2t3uVceLuZDxOWA9SBNDAgZSdO_532Q@mail.gmail.com>
 <CAL7ro1FF_q7FEJdevWrqvugkJ9S8bU5MxcoHHrLC3D834u4+zQ@mail.gmail.com>
 <CAOQ4uxgo9LOM3minBH0vw3huxjrHmO5O-caGfhgOUGCuT0B9Vg@mail.gmail.com>
 <20230616052444.GA181948@sol.localdomain>
 <CAOQ4uxjBfPvDb5921vV+jO1wtgoeWenEietmK6orP7Bh+gROqw@mail.gmail.com>
 <CAL7ro1FSPYL=P+h_qUXw=NHzPx89vR24dbZc8UOtVeYMqg5xrw@mail.gmail.com>
 <CAOQ4uxjSLwx3NsrXJAir5DLjY-Xo5e7Qs5NjK1gFygsbTO3E-g@mail.gmail.com>
 <CAL7ro1EYAPZYcqAiiR7r6HX2kp4XiWby0OBCEjYodNjP4VD18A@mail.gmail.com>
 <CAOQ4uxig=DHThgTr97ga4oGmoGshxa5f+or9gbjxXZ=qTDHHgg@mail.gmail.com>
 <CAL7ro1FUPQnwiN43jRZWAgdczPgYKj2H6Scx081gS-V+sC7cqA@mail.gmail.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAL7ro1FUPQnwiN43jRZWAgdczPgYKj2H6Scx081gS-V+sC7cqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 2023/6/16 19:33, Alexander Larsson wrote:
> On Fri, Jun 16, 2023 at 11:28 AM Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> On Fri, Jun 16, 2023 at 11:39 AM Alexander Larsson <alexl@redhat.com> wrote:
>>>
>>> On Fri, Jun 16, 2023 at 10:12 AM Amir Goldstein <amir73il@gmail.com> wrote:
>>>>
>>>>
>>>>> I don't believe this format will actually need to change much.
>>>>> However, I do agree
>>>>> with the general requirement for *some* ability to move forward with
>>>>> this format,
>>>>> so I'm gonna go with a single version byte.
>>>>>
>>>>
>>>> I disagree.
>>>> If you present a real life use case why that really matters
>>>> then I can reconsider.
>>>
>>> I disagree, but I'll add them.
>>>
>>
>> Let's ask for a 3rd opinion.
>> don't add them for now, unless Miklos says that you should.
> 
> I added them to the branch anyway for now. However, if we're going
> full header + flags anyway, I wonder if we really need the
> "overlay.digest" xattr at all? We could just put the header + optional
> digest in the "overlay.metacopy" xattr, and then just read/store one
> xattr. Right now metacopy is zero size, but adding some data to it
> would not break ovl_check_metacopy_xattr() in older kernels.
> 
> Basically, during the lookup we get the metacopy xattr anyway, and
> when we do we could record in a flag that there is a digest in it,
> then during open we don't have to look for a separate digest xattr,
> just re-load the metacopy xattr if the flag is set. With this in place
> we can also easily add other flags to overlay.metacopy, which imho
> makes a ton more sense than adding flags to overlay.digest.

My own slight concern about this is that:

Previously, all metacopy inodes shares a common EROFS shared xattr
which can be cached in memory once when the first read and other
inodes won't trigger any I/Os for this.

If "overlay.metacopy" xattr is not empty thus it cannot be shared,
I guess at least you could place it into an EROFS inline xattr, that
may be good as well if you also keep "header + flags".

But I'm not sure if it's a good idea to keep the full fsverity
digest in "overlay.metacopy" honestly, especially overlayfs
fsverity feature is off.  That will amplify I/Os (which could be
landed in EROFS shared xattrs as "overlay.digest" in the past and
now we need to read it immediately.)

Especially for the "ls -lR" workload, I guess you might need to
evaluate this way (only add flags vs flags + digest in
"overlay.metacopy") first.

Thanks,
Gao Xiang

> 
> I'll have a look at this.
> 
