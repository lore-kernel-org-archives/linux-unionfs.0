Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFA2C7EE29
	for <linux-unionfs@archiver.kernel.org>; Thu, 25 May 2023 17:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240262AbjEYR1z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 25 May 2023 13:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239995AbjEYR1y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 May 2023 13:27:54 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766AC9B
        for <linux-unionfs@vger.kernel.org>; Thu, 25 May 2023 10:27:50 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VjSybsM_1685035666;
Received: from 30.121.4.252(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VjSybsM_1685035666)
          by smtp.aliyun-inc.com;
          Fri, 26 May 2023 01:27:47 +0800
Message-ID: <c16e331e-601a-51b7-f209-2fa73389bd35@linux.alibaba.com>
Date:   Fri, 26 May 2023 01:27:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
References: <20230427130539.2798797-1-amir73il@gmail.com>
 <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <87h6s0z6rf.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Giuseppe,

On 2023/5/26 09:59, Giuseppe Scrivano wrote:
> Hi Amir,
> 
> Amir Goldstein <amir73il@gmail.com> writes:
> 
>> On Thu, May 25, 2023 at 6:21 PM Alexander Larsson <alexl@redhat.com> wrote:
>>>
>>> Something that came up about this in a discussion recently was
>>> multi-layer composefs style images. For example, this may be a useful
>>> approach for multi-layer container images.
>>>
>>> In such a setup you would have one lowerdata layer, but two real
>>> lowerdirs, like lowerdir=A:B::C. In this situation a file in B may
>>> accidentally have the same name as a file on C, causing a redirect
>>> from A to end up in B instead of C.
>>>
>>
>> I was under the impression that the names of the data blobs in C
>> are supposed to be content derived names (hash).
>> Is this not the case or is the concern about hash conflicts?
>>
>>> Would it be possible to have a syntax for redirects that mean "only
>>> lookup in lowerdata layers. For example a double-slash path
>>> //some/file.
>>>
>>
>> Anything is possible if we can define the problem that needs to be solved.
>> In this case, I did not understand why the problem is limited to finding a file
>> by mistake in layer B.
>>
>> If there are several data layers A:B::C:D why wouldn't we have the same
>> problem with a file name collision between C and D?
> 
> the data layer is constructed in a way that files are stored by their
> hash and there is control from the container runtime on how this is
> built and maintained.  So a file name collision would happen only when
> on a hash collision.
> 
> Differently for the other layers we've no control on what files are in
> the image, unless we limit to mount only one EROFS as the first lower
> layer and then all the other lower layers are data layers.
> 
> Given your example above A:B::C:D, if both A and B are EROFS we are
> limited in the files/directories that can be in B.

If my understanding is correct (hopefully), I might ask if it's the
proposal to pass in multiple composefs manifests (rather than one)
all together to overlayfs in one shot?

> 
> e.g. we have A/foo with the following xattrs:
> 
> trusted.overlay.metacopy=""
> trusted.overlay.redirect="/1e/de1743e73b904f16924c04fbd0b7fbfb7e45b8640241e7a08779e8f38fc20d"
> 
> Now what would happen if /1e is present as a file in layer B?  It will
> just cause the lookup for `foo` to fail with EIO since the redirect
> didn't find any file in the layers below.

If my understanding is correct, alternative one way might one do
a merged manifest before mounting? (of course a new manifest is
generated, but I think if it could be acceptable since the whole
merging process is under control?)

My overall thought is that it seems another seperate new
enhancement (if it needs more discussion) and have we might need
to land this lazy lookup first upstream as the first step?
(since our internal overlayfs users benefit this optimization
  as well... I'd like to see it upstream)

If it's a pure use case discussion, ignore me. ;)

Many thanks,
Gao Xiang

> 
> 
