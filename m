From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Wed, 26 Oct 2016 13:12:57 +0200
Message-ID: <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34004 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754525AbcJZLNN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Oct 2016 07:13:13 -0400
Received: by mail-oi0-f68.google.com with SMTP id p136so10694054oic.1
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Oct 2016 04:12:59 -0700 (PDT)
In-Reply-To: <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Raphael Hertzog <hertzog@debian.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 25, 2016 at 1:57 PM, Raphael Hertzog <hertzog@debian.org> wrote:

> Do you plan to make it the default in the future when it has been
> available for a while?
>
> Barring any regression introduced by your patch, it seems that the feature
> is best available by default since it allows legitimate operations to
> succeed that are otherwise refused. I understand that it makes it
> impossible to mount the overlay filesystem with an older kernel but is
> that problem more widespread than the one we're fixing here?  On my side,
> overlayfs is only used in scenarios where the kernel is always the same
> (or newer compared to what created the initial filesystem).

I think it would be safe to make it the default if upperdir is empty.
Nonempty implies that it was created with old kernel (or it was
crafted by hand).   But there should be a way to explicitly turn it
off;  either because of the need for backward compatibility or because
the old format is simply easier to work with for humans.

How about:

- If upper is nonempty, then leave redirect feature alone except when
mount option "-oredirect=on" is used to force enabling it.
- If upper is empty, then enable redirect feature except when mount
option "-oredirect=off" is used to force disabling it.

Thanks,
Miklos
