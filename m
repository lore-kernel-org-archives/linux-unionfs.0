From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [OVERLAYFS] Can I create file in directory on lower layer located
 on NFS
Date: Tue, 17 Oct 2017 09:11:57 +0200
Message-ID: <CAJfpegvXnyUeLJEDSJwnQ_mL6okjqin=E6fw_Wj=aezyNgiwNw@mail.gmail.com>
References: <CAAeanMz7d7UpoVj-yebH-66B-wF0kxT1vwJdQR73kKu=6TQdYA@mail.gmail.com>
 <CAOQ4uxhxU0PYe=aV2OR5UpU_fDTAWe6ex1m_oq0nCq8OGK-eJQ@mail.gmail.com>
 <CAAeanMzpzsNVxCaOHp=0t=5dcQG7BcOUbogZ_t1T3cDTZTzQ1A@mail.gmail.com> <CAOQ4uxgep4MRSCgauT79UsEVHZ0A_reOOyAvh4n3viW2LLS14A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:56084 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932521AbdJQHL7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 03:11:59 -0400
Received: by mail-wr0-f170.google.com with SMTP id 22so558636wrb.12
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 00:11:58 -0700 (PDT)
In-Reply-To: <CAOQ4uxgep4MRSCgauT79UsEVHZ0A_reOOyAvh4n3viW2LLS14A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: charles zheng <czheng2@nd.edu>, overlayfs <linux-unionfs@vger.kernel.org>, Lukas Rupprecht <Lukas.Rupprecht@ibm.com>, Vasily <vtarasov@us.ibm.com>, Douglas Thain <dthain@nd.edu>, Dean Hildebrand <seattleplus@gmail.com>, dimitrios.skourtis@ibm.com, mmohamed@us.ibm.com, aswarke@us.ibm.com

On Tue, Oct 17, 2017 at 7:37 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Since the error happens on such as old kernel as well as a new one, I suspect
> copy up fails on copying extended attributes of lower_dir.
> I suspect there are some NFS related xattr on lower dir?
> and perhaps those cannot be set on your upper fs?
> You did not reveal in mountinfo snippet what you local upper fs is
> and what mount options it uses.
>
> Please try to check if lower dir contains any xattr and
> if your upper fs supports xattr.

Yes, there's an NFSv4 related splat because overlayfs can't copy up
"system.nfs4_acl" xattr.  The weird but apparently unfixable fact is
that this attribute is there even if the nfs4-acl is equivalent to the
DAC bits (i.e. the common case).

If you don't want to use NFS acls, then just turn them off with
"noacl" mount option on the NFS mount and things should work.

Thanks,
Miklos
