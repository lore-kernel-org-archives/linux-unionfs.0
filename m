Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BCEC38142
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Jan 2023 03:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjARDl6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 22:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjARDlz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Jan 2023 22:41:55 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0B153FBC
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Jan 2023 19:41:53 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id v6so6951507ilq.3
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Jan 2023 19:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eitmlabs-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KNEkL77+Yf10oyJKy3gBDpH06+cEzlkxsfnfr0mnfTo=;
        b=oiy1xxThU4TFxhrAjE4jpkIiZq0/F5ktgVCk6aJt7iQ87rcGRpNxwun+e96tcls+Cg
         BfW4+OLjuZ0K+Dz70cqs8lph8Y5UR7Jqtp2v4tEALqp630TySTyD1XmPEOIRXtYi/MIV
         s9jb6lpgMWaefgtJ6YogmQ29Uf+Fpv6qgauk3jFjBL2B318a2yGPaFJe1sgNIByPlcRS
         OjleCEHthooLMneQb87mjnH8XJPVM2RNETm1TGs21GKuVXVXy14TbWfDRB0VEH/ERbgn
         M7qlkF79CorfUc5CLHPjA8LxbKdTMWm+CG+9CNW8wUxaVar9tlUchDTLvgMzr5AcvW4+
         87aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KNEkL77+Yf10oyJKy3gBDpH06+cEzlkxsfnfr0mnfTo=;
        b=PTcfIruLJmDFS06QFX4PPCHeA4d4YSDQ0TjCtwPJ486glzBPMyH6c1aSBGiYV/W6uF
         TkhglygtPuQyqR8XLnJWRQUkG6tUJDjhIUwFp1LPiJiLC/YSq50mGR1txbpxDXYm7dfJ
         fwJKwdK0FkVnoSfGRG7UMMFip+U9gmPEvFRk5Kc21CIVh16VOrEgc8c3ZmrAaKfCdhqR
         Yw+svQvYBLhMFgfOr3qLE6eP2nw4Y7reaSJneDvD+TyzVJa952djqdlQ+joQQ1vu3bjJ
         zxd5ug0yzO2eJRqu840tX10Ihgf/QT191F+IuV8Ul4bTkOpF/+cEXOQxzjdFncaS2f9u
         l/Hw==
X-Gm-Message-State: AFqh2kpUWQKrbWbGEAjLE2mkbVj74i/1fHb3VPplrMqTE3o0/r/LXiWr
        oyIY0iJM0wEO68tXeCh9kxaMrpsW8AOcVildUvU=
X-Google-Smtp-Source: AMrXdXtjU9IvuRmxEnZdXLhtBtHEFFNLDGdXdyTm2tLugU+NULYRyziEbXCZHfGHYW3aaARACHUSKA==
X-Received: by 2002:a92:3601:0:b0:30f:1c5:fb89 with SMTP id d1-20020a923601000000b0030f01c5fb89mr4634861ila.5.1674013312438;
        Tue, 17 Jan 2023 19:41:52 -0800 (PST)
Received: from [10.20.22.12] ([64.124.71.89])
        by smtp.gmail.com with ESMTPSA id b91-20020a0295e4000000b0038a760ab9a4sm4850261jai.161.2023.01.17.19.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 19:41:51 -0800 (PST)
Message-ID: <490c5026-27bd-1126-65dd-2ec975aae94c@eitmlabs.org>
Date:   Tue, 17 Jan 2023 19:41:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Reply-To: jonathan@eitm.org
Subject: Re: [PATCH] [REGRESSION] ovl: Handle ENOSYS when fileattr support is
 missing in lower/upper fs
Content-Language: en-US
To:     =?UTF-8?Q?Christian_Kohlsch=c3=bctter?= 
        <christian@kohlschutter.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
 <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com>
 <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
 <FFA26FD1-60EF-457E-B914-E1978CCC7B57@kohlschutter.com>
 <CAJfpeguDAJpLMABsomBFQ=w6Li0=sBW0bFyALv4EJrAmR2BkpQ@mail.gmail.com>
 <A31096BA-C128-4D0B-B27D-C34560844ED0@kohlschutter.com>
 <CAJfpegvBSCQwkCv=5LJDx1LRCN_ztTh9VMvrTbCyt0zf7W2trw@mail.gmail.com>
 <CAHk-=wjg+xyBwMpQwLx_QWPY7Qf8gUOVek8rXdQccukDyVmE+w@mail.gmail.com>
 <EE5E5841-3561-4530-8813-95C16A36D94A@kohlschutter.com>
 <CAHk-=wh5V8tQScw9Bgc8OiD0r5XmfVSCPp2OHPEf0p5T3obuZg@mail.gmail.com>
 <CAJfpeguXB9mAk=jwWQmk3rivYnaWoLrju_hq-LwtYyNXG4JOeg@mail.gmail.com>
 <CAHk-=wg+bpP5cvcaBhnmJKzTmAtgx12UhR4qzFXXb52atn9gDw@mail.gmail.com>
 <56E6CAAE-FF25-4898-8F9D-048164582E7B@kohlschutter.com>
From:   Jonathan Katz <jkatz@eitmlabs.org>
In-Reply-To: <56E6CAAE-FF25-4898-8F9D-048164582E7B@kohlschutter.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org


On 7/18/22 13:33, Christian Kohlschütter wrote:
>> Am 18.07.2022 um 22:12 schrieb Linus Torvalds <torvalds@linux-foundation.org>:
>>
>> On Mon, Jul 18, 2022 at 12:28 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> So this is a bug in the kernel part of fuse, that doesn't catch and
>>> convert ENOSYS in case of the ioctl request.
>> Ahh, even better. No need to worry about external issues.
>>
>>             Linus
> My concern was fixing it in fuse instead of ovl would leave non-fuse filesystems affected (even though I don't have proof that such filesystems exist).
>
> I'm glad you are OK with Miklos' change; the outcome of this discussion certainly adds some nuance to the famous "don't break userspace" / error code thread from 2012.
>
> Best,
> Christian
>
I believe that I am still having issues occur within Ubuntu 22.10 with 
the 5.19 version of the kernel that might be associated with this 
discussion.  I apologize up front for any faux pas I make in writing 
this email.

An example error from our syslog:

kernel: [2702258.538549] overlayfs: failed to retrieve lower fileattr 
(8020 MeOHH2O 
RecoverySample2-20221219-A-JJL-WebinarHilic10C-TOF-TT54-Neg-1722.d/analysis.tsf, 
err=-38)

The only other related log notification I get occurs when I do the 
overlay mount:

kernel: [2702222.266404] overlayfs: null uuid detected in lower fs '/', 
falling back to xino=off,index=off,nfs_export=off.


In the following description, the error is occurring on FileServer2

Our configuration is as follows:

FileServer1 "/data" --- NFS(ro)----->  FileServer2

On FileServer2 I wish to export that /data directory via Samba so it 
appears as RW by a specific user.  I accomplish this with bindfs 
followed by overlayfs:

# bindfs -u 1001 -g 1001 /data /overlay/lowers/data-1001
# mount -t overlay overlay -o lowerdir= /overlay/lowers/data-1001,\
upperdir=/overlay/uppers/upper-1001,\
workdir=/overlay/work/work-1001,\
/overlay/mountpoints/data-1001

Then I serve this out via Samba:

FileServer2 "/overlay/mountpoints/data-1001" ------ ( SAMBA/CIFS) --->  
Win-Client


I repeat this bind/mount for several users - each with their own 
"writable" copy of the data.  This mostly works very well... but there 
are some software packages on the win client that fail mysteriously and 
my FileSystem2 log shows "err=-38" messages for various files at the 
same time.

I am guessing there is some relation between the lack of uuid (because 
it is NFS or a bindfs?) and the failure to retrieve the low fileattr, 
but, I am humbly out of my depth here.

-Jonathan



