From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/3] ovl: check fs features
Date: Sat, 5 Nov 2016 22:40:40 +0200
Message-ID: <CAOQ4uxizPVbaKNXuiTMH0AsGkFqSdXfXsouecyzqyZrNpB+Qhg@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-2-git-send-email-mszeredi@redhat.com> <CAOQ4uxjeP0J=rmC8fHScnKoMHiF7Bmm7k-Y0sf2YFf-OcxJx4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33694 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755844AbcKEUkn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 5 Nov 2016 16:40:43 -0400
In-Reply-To: <CAOQ4uxjeP0J=rmC8fHScnKoMHiF7Bmm7k-Y0sf2YFf-OcxJx4w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org

On Tue, Oct 25, 2016 at 2:24 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Oct 25, 2016 at 10:34 AM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>> To allow adding new, backward incompatible features to overlayfs, we need a
>> way to store the list of features in the overlay.  This is done via
>> "trusted.overlay.features" xattr on the root of the upper layer (or one of
>> the lower layers, that previously acted as an upper layer).  It's a comma
>> separated list of case sensitive strings.
>>
>> If an overlay has an unknown feature, mount shall return an error.  So
>> mechanism should only be used for backward incompatible features.
>
> So maybe be explicit and call the attribute trusted.overlay.incompat_features,
> to allow future addition of compat and rocompat feature sets?
>

On top of the proposed features xattr,
for the sake of being backward compatible with old kernels,
how about creating a file 3 levels down from work dir (e.g. /work/work/a/b/c)
This would cause old kernels to mount overlay read-only,
which is sufficient to keep them from corrupting the redirect structure.

And once again, I suggest learning from the elders fs, who have
successfully gone through many on-disk format upgrades,
and copy the design of the feature trio (compat/incompat/rocompat)

Amir.
