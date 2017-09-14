From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: ovl: mounting two times the same mount overlayfs will not list
 any directory entry anymore
Date: Thu, 14 Sep 2017 12:12:06 +0200
Message-ID: <CAJfpegtRqtAG=9mr48VjbL-OuM9cVmPh3Qpc1mFu4EaoaJZEuQ@mail.gmail.com>
References: <20170912113853.05b08228@localdomain> <CAOQ4uxgEShUQzf5Spu69qrV5BfZ8t_ibLbpAF0t8N8nHH4Qv8Q@mail.gmail.com>
 <CACTE=goZ_TCDh7wEoLe_CRFvNLzsN2k_m46G-nGCB38C6=P_Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:46732 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdINKMI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Sep 2017 06:12:08 -0400
Received: by mail-wm0-f48.google.com with SMTP id i189so9689090wmf.1
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Sep 2017 03:12:07 -0700 (PDT)
In-Reply-To: <CACTE=goZ_TCDh7wEoLe_CRFvNLzsN2k_m46G-nGCB38C6=P_Eg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Andrei Vagin <avagin@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Ram Pai <linuxram@us.ibm.com>

On Tue, Sep 12, 2017 at 3:04 PM, Jordi Pujol <jordipujolp@gmail.com> wrote:
> On Tue, Sep 12, 2017 at 12:47 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> So is this reproducible at every run with v4.13?
> yes,
>
>> Are you able to try this without overlayfs? i.e. chroot to squashfs mount?
> I have found the same in 4.12 when mounting only one squashfs image.
> Therefore we could say that when working with previous versions
> overlayfs was solving the problem in some way.

Can you please post the contents of /proc/self/mountinfo?

Thanks,
Miklos
