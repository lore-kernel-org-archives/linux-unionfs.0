Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B2CC77B73
	for <linux-unionfs@archiver.kernel.org>; Sat, 27 May 2023 14:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjE0OaR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 27 May 2023 10:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjE0OaQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 27 May 2023 10:30:16 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E53BBE
        for <linux-unionfs@vger.kernel.org>; Sat, 27 May 2023 07:30:13 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Vja4mpU_1685197808;
Received: from 192.168.2.5(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vja4mpU_1685197808)
          by smtp.aliyun-inc.com;
          Sat, 27 May 2023 22:30:10 +0800
Message-ID: <c8f24ae0-cd40-af46-12dc-1d87d4ae5abd@linux.alibaba.com>
Date:   Sat, 27 May 2023 22:30:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
References: <20230427130539.2798797-1-amir73il@gmail.com>
 <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com>
 <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com>
 <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Amir,

On 2023/5/27 22:04, Amir Goldstein wrote:
> On Fri, May 26, 2023 at 9:27 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>> Hi,
>>
>> On 2023/5/26 04:36, Alexander Larsson wrote:
>>> On Fri, May 26, 2023 at 7:12 AM Amir Goldstein <amir73il@gmail.com> wrote:
>>>>
>>>> On Thu, May 25, 2023 at 7:59 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>>>>>
>>>>> Hi Amir,
>>>>>
>>>>> Amir Goldstein <amir73il@gmail.com> writes:
>>>>>
>>>>>> On Thu, May 25, 2023 at 6:21 PM Alexander Larsson <alexl@redhat.com> wrote:
>>>>>>>
>>>>>>> Something that came up about this in a discussion recently was
>>>>>>> multi-layer composefs style images. For example, this may be a useful
>>>>>>> approach for multi-layer container images.
>>>>>>>
>>>>>>> In such a setup you would have one lowerdata layer, but two real
>>>>>>> lowerdirs, like lowerdir=A:B::C. In this situation a file in B may
>>>>>>> accidentally have the same name as a file on C, causing a redirect
>>>>>>> from A to end up in B instead of C.
>>>>>>>
>>>>>>
>>>>>> I was under the impression that the names of the data blobs in C
>>>>>> are supposed to be content derived names (hash).
>>>>>> Is this not the case or is the concern about hash conflicts?
>>>>>>
>>>>>>> Would it be possible to have a syntax for redirects that mean "only
>>>>>>> lookup in lowerdata layers. For example a double-slash path
>>>>>>> //some/file.
>>>>>>>
>>>>>>
>>>>>> Anything is possible if we can define the problem that needs to be solved.
>>>>>> In this case, I did not understand why the problem is limited to finding a file
>>>>>> by mistake in layer B.
>>>>>>
>>>>>> If there are several data layers A:B::C:D why wouldn't we have the same
>>>>>> problem with a file name collision between C and D?
>>>>>
>>>>> the data layer is constructed in a way that files are stored by their
>>>>> hash and there is control from the container runtime on how this is
>>>>> built and maintained.  So a file name collision would happen only when
>>>>> on a hash collision.
>>>>>
>>>>> Differently for the other layers we've no control on what files are in
>>>>> the image, unless we limit to mount only one EROFS as the first lower
>>>>> layer and then all the other lower layers are data layers.
>>>>>
>>>>> Given your example above A:B::C:D, if both A and B are EROFS we are
>>>>> limited in the files/directories that can be in B.
>>>>>
>>>>> e.g. we have A/foo with the following xattrs:
>>>>>
>>>>> trusted.overlay.metacopy=""
>>>>> trusted.overlay.redirect="/1e/de1743e73b904f16924c04fbd0b7fbfb7e45b8640241e7a08779e8f38fc20d"
>>>>>
>>>>> Now what would happen if /1e is present as a file in layer B?  It will
>>>>> just cause the lookup for `foo` to fail with EIO since the redirect
>>>>> didn't find any file in the layers below.
>>>>>
>>>>>
>>>>
>>>> I understand the problem and I understand why a // redirect to data-only layers
>>>> would be a simple and workable solution for composefs.
>>>>
>>>> Unlike the rest of the changes to overlayfs that we worked on to support
>>>> composefs, this would really be a composefs only on-disk format because it
>>>> could not be generated by overlayfs itself, so we need Miklos to chime in to
>>>> say if this is acceptable.
>>
>> An alternative way might allow data-only layers (or invisible layers) in the
>> middle rather than as the tail?
>>
> 
> Anything is possible if you can justify its worth.

TBH, I have no strong tendency of this for now.  But the hidden layers
(just for redirection) might be useful if they're used for data provider
only and my potential concern might be too strict so that we lose the
later extendibility...

> 
>> I'm not sure in the long term if it's flexible to fix data-only layers as the
>> bottom-most layers for future potential use cases.
>>
>> At a quick glance, I've seen the implementation of this patchset also
>> strictly code that.   I wonder if using non-fixed invisible layers increases
>> the complexity or am I still missing something?
>>
> 
> The current implementation is quite simplified due to keeping data-only
> layers in the tail, and even more simplified that lazy lowerdata lookup
> is only in the data-only layers at the tail of the stack.
> The documentation is also simpler as do the tests.
> 
> Making all the the above more complex needs justification and so far
> I did not see any use case that would justify it, because the /.cfs
> workaround is good enough IMO.
> 
> That leaves the question - is the design/API flexible enough to be
> extended in the future if we needed to?

Yeah, that is what I'd like to mention for now, at least leave
some extendibility for option format...

Thanks,
Gao Xiang

> 
> If we would want to support data-only layers in the middle on the
> stack, which would this syntax make sense?
> lowerdir=lower1::data1:lower2::data2
> 
> If this syntax makes sense to everyone, then we can change the syntax
> of data-only in the tail from lower1::data1:data2 to lower1::data1::data2
> and enforce that after the first ::, only :: are allowed.
> 
> Miklos, any thoughts?
> I have a feeling that this was your natural interpretation when you first
> saw the :: syntax.
> 
> Thanks,
> Amir.
