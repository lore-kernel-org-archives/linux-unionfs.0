Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F9FC433EF
	for <linux-unionfs@archiver.kernel.org>; Sun, 27 Feb 2022 13:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiB0NZ4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 27 Feb 2022 08:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiB0NZz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 27 Feb 2022 08:25:55 -0500
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6445F57B3A
        for <linux-unionfs@vger.kernel.org>; Sun, 27 Feb 2022 05:25:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645968297; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=pwannUS1eL4yAiouP2SXgVpkN9CJt8QO6L17stOQS/Ye/FF3c0hTuKVguplbUuWm4cIS7xymFxJZ8XR+i6SlAYfXDPvx5+AC0/XKtdvNAOI7cp3/1E4692bDDZSpXlnK4MaX1thFOMHai2ucOpfG40Go4l2XhnjciIAejnkjtiY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1645968297; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=IBf1q3VCs4wmIHndOmz0bXADNJMXp+1jPxIp4ghzCuY=; 
        b=Uq0YFcFOioLRKKpzVm7ZuFmgqcMAfbuJGGFGPjqfhXUIWtCiLPP6du51i+B2Gub6ZNCzO/YLJ3l2kg+ifdR7a0ylUBIPQ6wHEyT7iShPMOic5mJQa0uf+8C3w+dWK7m23iDnnX3Gf6kqUGx7gCFsw/5So84L9P6oWABUb6mB7X0=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645968297;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:MIME-Version:Subject:To:Cc:References:From:Message-ID:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=IBf1q3VCs4wmIHndOmz0bXADNJMXp+1jPxIp4ghzCuY=;
        b=fbOL102vr2FVtiI3qoVB4cU5b7KkdsI1ThFObWNH3g35JXexaz8PsRouAYqilTIA
        Fn8+Su0z7OX44Wy85ZVLBluxcO8zCWyfQA7H/1pNM4rSgl8SyBnMyedASQz+D8i26SQ
        SywK3pGseVj3RQ3a4ZJhMuQq6hqCgaf/i93OR184=
Received: from [192.168.255.10] (113.116.49.66 [113.116.49.66]) by mx.zoho.com.cn
        with SMTPS id 1645968296449308.1093027477848; Sun, 27 Feb 2022 21:24:56 +0800 (CST)
Date:   Sun, 27 Feb 2022 21:24:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [RFC PATCH] ovl: fsync parent directory in copy-up
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
References: <20220226152058.288353-1-cgxu519@mykernel.net>
 <CAOQ4uxiWZ4TWq4LuNOHYMHDgX+2Srq_3HNe+t5z-Ch4AFw9bRA@mail.gmail.com>
 <3a37de83-a48d-e0b5-f934-c4b4219de7fe@mykernel.net>
 <CAOQ4uxgOxgXiDZocixLLp253_DDC-3X7SGQoLc1Vv7s2F1g+EQ@mail.gmail.com>
From:   Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <c9705270-72bc-d446-0f58-6e803d2367e5@mykernel.net>
In-Reply-To: <CAOQ4uxgOxgXiDZocixLLp253_DDC-3X7SGQoLc1Vv7s2F1g+EQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

=E5=9C=A8 2022/2/27 13:16, Amir Goldstein =E5=86=99=E9=81=93:
> On Sun, Feb 27, 2022 at 6:28 AM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
>> =E5=9C=A8 2022/2/27 0:38, Amir Goldstein =E5=86=99=E9=81=93:
>>> On Sat, Feb 26, 2022 at 5:21 PM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
>>>> Calling fsync for parent directory in copy-up to
>>>> ensure the change get synced.
>>> It is not clear to me that this change is really needed
>>> What if the reported problem?
>> I found this issue by eyeball scan when I was looking for
>> the places which need to mark overlay inode dirty in change.
>>
>> However, I think there are still some real world cases will be impacted
>> by this kind of issue,
>> for example, using docker build to make new docker image and power
>> failure makes new
>> image inconsistant.
> A very good example where the fsync of parent will be counter productive.
> The efficient way of building a docker image would be:
> 1. Write/copy up all the files
> 2. Writeback all the upper inodes
> 3. syncfs() upper fs
>
> 2 and 3 should happen on overlayfs umount as long as we properly
> marked all the copied up overlayfs inodes dirty.
>
> So the question is not if parent dir needs fsync, but if it needs to be
> dirtied.
>
>>
>>> Besides this can impact performance in some workloads.
>>>
>>> The difference between parent copy up and file copy up is that
>>> failing to fsync to copied up data and linking/moving the upper file
>>> into place may result in corrupted data after power failure if temp
>>> file data is not synced.
>>>
>>> Failing the fsync the parent dir OTOH may result in revert to
>>> lower file data after power failure.
>>>
>>> The thing is, although POSIX gives you no such guarantee, with
>>> ext4/xfs fsync of the upper file itself will guarantee that parents
>>> will be present after power failure (see [1]).
>> In the new test case (079) which I posted, I've tried xfs as underlying
>> fs and found the parent of
>> copy-up file didn't present after power failure. Am I missing something?
>>
> I think you are.
> The test does not reproduce an inconsistency.
> The test reproduced changes that did not persist to storage after
> power failure and that is the expected behavior when a user does
> not fsync after making changes - unless the 'sync' or 'dirsync' mount
> options have been used.
>
> I think your test will become correct if you use -o sync for the overlayf=
s
> mount and your patch will become correct if you do:
>
> +        if (inode_needs_sync(d_inode(dentry)) {
> +               parent_file =3D ovl_path_open(&parentpath, O_DIRECTORY|O_=
RDONLY);

Why should parent_file open with O_RDONLY flag? Meanwhile, I think the=20
fix is not sufifcient for fully supporting 'dirsync' or 'sync' in overlayfs=
.
Anyway, I think the description of expected behavior above makes sense=20
so maybe the topic should turn to implement 'sync' or 'dirsync' mount
options or reject specifying those options in overlayfs.


Thanks,
Chengguang



