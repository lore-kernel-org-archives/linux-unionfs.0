Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:57477 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725885AbeJ3KnT (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 Oct 2018 06:43:19 -0400
Subject: Re: [PATCH] ovl: disable new features for deprecated upper fs
References: <CAOQ4uxjSB_7cnu71EvZ+uOTgfMKsbNxQ+Fd8cVjfFhMo=EiMOg@mail.gmail.com>
 <20181026192039.GA29504@redhat.com>
 <CAJfpegswL4mxfRigx0jDtTwta0Kdpv9Lh3cGuP+r6dvP7s_iyQ@mail.gmail.com>
 <20181026195215.GB29504@redhat.com> <20181026200739.GC29504@redhat.com>
 <CAJfpegtCa5+_wC11TKC8s=R3-vaONe5WxHm=oHzq1BG4kPJanQ@mail.gmail.com>
 <CAOQ4uxhOJye--zmEB4=Xuwnq4pMKGtbKq4b_0LZZLFG90BgFwQ@mail.gmail.com>
 <20181026212234.GD29504@redhat.com> <20181026213311.GA6155@redhat.com>
 <CAOQ4uxhf-aabMgrQt2_a5bqXUuuSi_QYst38tMJ0wV0xZzSc4Q@mail.gmail.com>
 <20181029191610.GC24630@redhat.com>
 <CAOQ4uxhhiYE-2E_ZAMj16aNnsk+QE1Wxvv+vkuOuhDXCg3Cp5w@mail.gmail.com>
 <CAOQ4uxhSnvznJ3VY1ovGy3yKbMi1mOZ_b-qjt1crXrzsxY81YQ@mail.gmail.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <12089ba7-5860-63aa-6e53-6124b7e755f2@huawei.com>
Date: Tue, 30 Oct 2018 09:51:52 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhSnvznJ3VY1ovGy3yKbMi1mOZ_b-qjt1crXrzsxY81YQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/10/30 5:32, Amir Goldstein Wrote:
> [adding back CC list, which I accidentally dropped a few emails back..]
> 
[..]
> 
> Adding another terrible idea to add to the pile of non perfect solutions.
> I never liked the 'feature=[on|off]' standard, which is different from the more
> common standard of '[feature|nofeature]' mount options.
> 
> What if we interpreted mount options 'feature=[on|off]' as advisory and
> mount options '[feature|nofeature]' as mandatory?
> 
> The mandatory semantics could mark the start of the mkfs.overlay era
> (a.k.a overlayfs on-disk format v2).
> Meaning that you can only mount with mandatory 'metacopy' if either:
> - upperdir AND workdir are empty
> OR
> - layers where created with mkfs.overlay with mandatory 'metacopy'
> OR
> - overlay was always mounted in the past with mandatory 'metacopy'
> OR
> - fsck.overlay is used to check layers and add mandatory 'metacopy'
> 
> Zhangyi,
> 
> Do you have plans to post another version of overlayfs feature set
> patches for kernel/overlayfs-progs anytime soon?
> 

Hi Amir,

Yes, I've done about 70% of the work for kernel, but I haven't started
yet for overlayfs-progs. I've been quite busy lately, and have to
postpone this work. Anyway, I will try to post the next version as soon
as posible.

Thanks,
Yi.
