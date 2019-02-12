Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190211165323.9369-1-iforster@suse.com> <20190211165323.9369-5-iforster@suse.com>
In-Reply-To: <20190211165323.9369-5-iforster@suse.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 12 Feb 2019 04:55:45 +0200
Message-ID: <CAOQ4uxhrGtPxUVBfxoiGLh_5+qktC_0CC+CaFrCpY4zYXi9xXQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] Ignore IMA / EVM xattrs during copy_up
Content-Type: text/plain; charset="UTF-8"
To: Ignaz Forster <iforster@suse.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-integrity <linux-integrity@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Fabian Vogt <fvogt@suse.com>, Ignaz Forster <iforster@suse.de>, Fabian Vogt <fvogt@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Feb 11, 2019 at 10:27 PM Ignaz Forster <iforster@suse.com> wrote:
>
> From: Ignaz Forster <iforster@suse.de>
>
> EVM tries to protect these attributes during copy_up, resulting in
> the failure of the copy_up operation.
>
> This patch will skip the attributes (similar to selinux) to allow
> for later recalculation. This, however, introduces another problem:
> As overlayfs does not check the file integrity on copy_up, files with
> an invalid hash will suddenly become valid again after the copy_up
> operation.
>

"overlayfs doesn't check" means the check is to high in vfs and
needs to move to lower vfs layer?
Same as fixes in vfs_create and vfs_tmpfile.

Thanks,
Amir.
