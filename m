From: Raphael Hertzog <hertzog@debian.org>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Tue, 25 Oct 2016 13:57:48 +0200
Message-ID: <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477380887-21333-4-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Guillem Jover <guillem@debian.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hello Miklos,

thanks for your work on this patch set!

On Tue, 25 Oct 2016, Miklos Szeredi wrote:
> +renaming directories
> +--------------------
> +
> +When renaming a directory that is on the lower layer or merged (i.e. the
> +directory was not created on the upper layer to start with) overlayfs can
> +handle it in two different ways:
> +
> +1) return EXDEV error: this error is returned by rename(2) when trying to
> +   move a file or directory across filesystem boundaries.  Hence
> +   applications are usually prepared to hande this error (mv(1) for example
> +   recursively copies the directory tree).  This is the default behavior.
> +
> +2) If the "redirect_dir" feature is enabled, then the directory will be
> +   copied up (but not the contents).  Then the "trusted.overlay.redirect"
> +   extended attribute is set to the path of the original location from the
> +   root of the overlay.  Finally the directory is moved to the new
> +   location.

>From this, I understand that we will have to add "redirect_dir" to the
mount options for this feature to work. Is there any reason why you
put this as an opt-in feature?

Do you plan to make it the default in the future when it has been
available for a while?

Barring any regression introduced by your patch, it seems that the feature
is best available by default since it allows legitimate operations to
succeed that are otherwise refused. I understand that it makes it
impossible to mount the overlay filesystem with an older kernel but is
that problem more widespread than the one we're fixing here?  On my side,
overlayfs is only used in scenarios where the kernel is always the same
(or newer compared to what created the initial filesystem).

Cheers,
-- 
Raphaël Hertzog ◈ Debian Developer

Support Debian LTS: http://www.freexian.com/services/debian-lts.html
Learn to master Debian: http://debian-handbook.info/get/
