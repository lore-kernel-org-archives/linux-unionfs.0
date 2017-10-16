From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 7/9] ovl: Introduce read/write barriers around metacopy
 flag update
Date: Mon, 16 Oct 2017 16:31:20 +0300
Message-ID: <CAOQ4uxjV_1WHh5P=Hv6BY+JhEkXFfPFLSNd0ZpbNf1s0hbdH2Q@mail.gmail.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
 <1507649544-4539-8-git-send-email-vgoyal@redhat.com> <CAOQ4uxisKjK+kH_kEMb7JPUHn+Gaoa7YNvQsS9W=REUPuywy+A@mail.gmail.com>
 <20171011202713.GF8086@redhat.com> <CAOQ4uxgKtG=6QdqPbrkHJTGFS_h2_9SmNeWphwso3uFtM4N4dg@mail.gmail.com>
 <20171013182706.GA23232@redhat.com> <CAOQ4uxj1eUq8OWaG4-Fw4Kx2v6jB4p5bwaU6S-iJU7j9vTwEhQ@mail.gmail.com>
 <20171016132453.GB31318@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:43345 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751376AbdJPNbW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Oct 2017 09:31:22 -0400
Received: by mail-qt0-f193.google.com with SMTP id j58so20492833qtj.0
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Oct 2017 06:31:21 -0700 (PDT)
In-Reply-To: <20171016132453.GB31318@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Mon, Oct 16, 2017 at 4:24 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Oct 14, 2017 at 09:05:17AM +0300, Amir Goldstein wrote:
>
> [..]
>> > When I read memory-barrier.txt, it seems to suggest that RELEASE can let
>> > instructions outside critical region sneak into critical region. If that's
>> > the case, actually clearing of metaflag can happen before xattr actually
>> > got removed. Though I can't think what will go wrong in that case.
>>
>> clear_bit takes a spinlock so I *think* clearing of flag cannot sneak
>> before removing xattr.
>
> Which spinlock does clear_bit take? Are you referring to ovl_inode->lock mutex?
>
See set_bit() and clear_bit() in
include/asm-generic/bitops/atomic.h
