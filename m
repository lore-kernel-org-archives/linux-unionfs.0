Return-Path: <SRS0=uqCX=CD=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5624DC433E1
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Aug 2020 18:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2503D2071E
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Aug 2020 18:23:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WqlD02LX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgHYSX6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 14:23:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgHYSX6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Aug 2020 14:23:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598379835;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=1mUSeeRvMZph4ZEud8iiTIkiGq0wQxwvuZhxywl8egQ=;
        b=WqlD02LXg2WyLFxN6HQu/jPNa1NodHghDRurHD4YwKLbbNTlxXnZxIZAdQaVt9GfY3znnn
        miRHp81xzr5IU8VtQrCTNnpgCbgb9kaIIVqYbv6tft5ZTZwsY+TFk05Ukh6v1/VzcpI3Y6
        GNYKdrr2rLZdPUCweJGkQbGWYkLouZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55--aMpnhCkOwGTPv_MsgGFqA-1; Tue, 25 Aug 2020 14:23:49 -0400
X-MC-Unique: -aMpnhCkOwGTPv_MsgGFqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EC2E10ABDB4;
        Tue, 25 Aug 2020 18:23:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.10.110.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D9BC60C0F;
        Tue, 25 Aug 2020 18:23:46 +0000 (UTC)
Reply-To: dwalsh@redhat.com
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip
 sync
To:     Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Steven Whitehouse <swhiteho@redhat.com>
References: <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
 <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
 <87a6yknugp.fsf@redhat.com>
 <CAOQ4uxg4xmvsoKVBfGJ0SVCXfM6aeNji6c8FSCevxV-FYX3LtQ@mail.gmail.com>
 <874kosnqnn.fsf@redhat.com>
 <CAJfpegvaUz_M0jtibOk=a6Cx=U9JBnOcVSmF2xM9cyVmCz8CFg@mail.gmail.com>
 <20200824135108.GB963827@redhat.com>
 <CAOQ4uxi9PoYzWxKF0c2a9zzxnrZMeB08Htomn1eHjYha-djLrA@mail.gmail.com>
 <20200824210053.GL963827@redhat.com>
 <CAOQ4uxhvi5wHhPKivrWzOJ8ygyETDVqc4h4MW6uYN=h1T2B+BA@mail.gmail.com>
 <20200825005504.GN963827@redhat.com>
 <CAOQ4uxjHs96Ehoi6JCTMjgGogUw3hgwPOrUJ73S79y9jU68Hjw@mail.gmail.com>
From:   Daniel Walsh <dwalsh@redhat.com>
Autocrypt: addr=dwalsh@redhat.com; prefer-encrypt=mutual; keydata=
 mQENBFsaqOEBCADBSnZCZpi262vX8m7iL/OdHKP9G9dhS28FR60cjd8nMPqHDNhQJBjLMZra
 66L2cCIEhc4HEItail7KU1BckrMc4laFaxL8tLoVTKHZwb74n2OcAJ4FtgzkNNlB1XJvSwC/
 909uwt7cpDqwXpJvyP3t17iuklB1OY0EEjTDt9aU4+0QjHzV18L4Cpd9iQ4ksu+EHT+pjlBk
 DdQB+hKoAjxPl11Eh6pZfrAcrNWpYBBk0A3XE9Jb6ghbmHWltNgVOsCa9GcswJHUEeFiOup6
 J5DTv6Xzwt0t6QB8nIs+wDJH+VxqAXcrxscnAhViIfGGS2AtxzjnVOz/J+UZPaauIGXTABEB
 AAG0LERhbmllbCBKIFdhbHNoIChGb3IgR2l0KSA8ZHdhbHNoQHJlZGhhdC5jb20+iQE4BBMB
 AgAiBQJbGqjhAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRCi35Adq+LAKHuJB/98
 nZB5RmNjMWua4Ms8q5a1R9XWlDAb3mrST6JeL+uV/M0fa18e2Aw4/hi/WZHjAjoypLmcuaRx
 GeCbC8iYdpfRDUG79Y956Qq+Vs8c6VfNDMY1mvtfb00eeTaYoOCu0Aa9LDeR9iLKh2g0RI+N
 Zr3EU45RxZdacIs1v6mU8pGpyUq/FvuTGK9GzR9d1YeVCuSpQKN4ckHNZHJUXyk0vOZft1oO
 nSgLqM9EDWA+yz1JLmRYwbNsim7IvfVOav5mCgnKzHcL2mLv8qCnMFZjoQV8aGny/W739Z3a
 YJo1CdOg6zSu5SOvmq9idYrBRkwEtyLXss2oceTVBs0MxqQ/9mLPuQENBFsaqOEBCADDl2hl
 bUpqJGgwt2eQvs0Z0DCx/7nn0hlLfEn4WAv2HqP25AjIRXUX31Mzu68C4QnsvNtY4zN+FGRC
 EfUpYsjiL7vBYlRePhIohyMYU4RLp5eXFQKahHO/9Xlhe8mwueQNwYxNBPfMQ65U2AuqxpcS
 scx4s5w208mhqHoKz6IB2LuKeflhYfH5Y1FNAtVGHfhg22xlcAdupPPcxGuS4fBEW6PD/SDf
 Y4HT5iUHsyksQKjM0IFalqZ7YuLfXBl07OD2zU7WI9c3W0dwkvwIRjt3aD4iAah544uOLff+
 BzfxWghXeo80S2a1WCL0S/2qR0NVct/ExaDWboYr/bKpTa/1ABEBAAGJAR8EGAECAAkFAlsa
 qOECGwwACgkQot+QHaviwCi2hgf/XRvrt+VBmp1ZFxQAR9E6S7AtRT8KSytjFiqEC7TpOx3r
 2OZ4gZ3ZiW4TMW8hS7aYRgF1uYpLzl7BbrCfCHfAWEcXZ+uG8vayg8G/mLAcNlLY+JE76ATs
 53ziEY9R2Vb/wLMFd2nNBdqfwGcRH9N9VOej9vP76nCP01ZolY8Nms2hE383/+1Quxp5EedU
 BN5W5l7x9riBJyqCA63hr4u8wNsTuQgrDyhm/U1IvYeLtMopgotjnIR3KiTKOElbppLeXW3w
 EO/sQTPk+vQ4vcsJYY9Dnf1NlvHE4klj60GHjtjitsBEHzdE7s+J9FOxPmt8l+gMogGumKpN
 Y4lO0pfTyg==
Organization: Red Hat
Message-ID: <58c33816-0516-240a-2042-b0d721abb3ba@redhat.com>
Date:   Tue, 25 Aug 2020 14:23:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjHs96Ehoi6JCTMjgGogUw3hgwPOrUJ73S79y9jU68Hjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 8/25/20 01:31, Amir Goldstein wrote:
> On Tue, Aug 25, 2020 at 3:55 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Tue, Aug 25, 2020 at 12:51:55AM +0300, Amir Goldstein wrote:
>>>> Ok, I am wondering why are we concerned about older kernels. I mean,
>>>> if we introduce new features, we don't provide compatibility with
>>>> older kernels. Say "metacopy", "redirect_dir". If you mount with
>>>> older kernel, they will see something which you don't expect.
>>>>
>>> True. We missed the opportunity to do the work/incompat trick
>>> with metacopy etc.
>>>
>>>> So why "volatile" is different. We seem to be bending backward and
>>>> using an unrelated behavior of overlay to provide this.
>>>>
>>>> Why not simply drop a file $workdir/volatile for volatile mounts
>>>> and check for presence of this file when mounting?
>>>>
>>> That's an option.
>>> But what's the problem with
>>>   $workdir/work/incompat/volatile/dirty
>>> compared to:
>>>   $workdir/volatile
>>>
>>> It's not more complicated to implement is it?
>>> So we get some extra protection with little extra cost. No?
>> Ok, I will look into it.
>>> I don't feel strongly about it.
>>>
>>> But I must say, according to Giuseppe's description of the use case:
>>> "mount volatile overlay+umount overlay+syncfs upper dir..."
>>> looks like what he is looking for is "volatile,sync=shutdown", is it not?
>>>
>>> And if this is the case, I think it would be much preferred to implement
>>> "volatile,sync=shutdown", over documenting how to make a "volatile"
>>> overlay mountable from outside overlay. Don't you guys agree?
>> When it comes to requirements, to me it felt that Giuseppe seemed
>> to have two requirements. For running containers, he did not care
>> seem to care about syncing upper to disk at all. For building
>> images he probably wanted to sync upper to disk.
>>
> You know, I am not sure that building images requires syncing to disk.
> Why is syncfs() needed between unmount and copying/tar'ing the layers?
> Why is it needed before mounting again? It is not.
> It is only needed "before crash", so whether or not "dirty volatile" overlay
> can be mounted is a decision better be made by userspace.
>
> The only problem with this approach is that it is a bit harder to document
> the filesystem behavior, but I think that we need to.
>
>> From overlayfs perspective, "volatile,sync=shutdown" seems like
>> a nicer interface because overlay will take care of removing
>> "dirty" file and until and unless crash happens, user does
>> not have to step in and there is less confusion about syncing
>> upper and removing dirty file etc.
>>
>> Last time Miklos seemed to prefer to implement just "volatile"
>> for now and drop "sync=shutdown".
>>
>> https://lore.kernel.org/linux-unionfs/CAJfpegt2k=r6TRok57tKPcLyUhCBOcBAV7bgLSPrQYXsPoPkpQ@mail.gmail.com/
>>
>> I personally think that "volatile,sync=shutdown" is first good step
>> because it is less error prone and overlayfs manages dirty file
>> and it will provide lot of benefits in terms of not having to
>> do very frequent sync.
>>
>> And if this does not prove to be enough for certain use cases,
>> then one can extend this to also implement "volatile,sync=none".
>>
>> But frankly speaking, there has been so much of back and forth
>> on this patch, that I am fine with any of the option which is
>> acceptable to Miklos.
>>
> I agree.
> Miklos accepted $workdir/work/incompat/volatile/dirty.
> I assume the name 'dirty'/'donotremove' is not an issue.
> It's simple.
> Let's go with that.
>
> Thanks,
> Amir.
>
I don't believe we need the sync=shutdown.  But I am fine with adding it.

in both cases we are looking at using this.  Buildah for building
container images

and CRI-O where Kubernetes comes in and blows away all of the containers
on system

restart, we don't care about data in the upper directory on a crash.


