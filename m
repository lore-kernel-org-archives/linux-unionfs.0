From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v2] ovl: update S_ISGID when setting posix ACLs
Date: Wed, 26 Oct 2016 20:52:43 +0200
Message-ID: <CAHc6FU6e1o9GhhjvKX=FA1XRQTjaBTP6n-NYa5FBD+kwo9UzjA@mail.gmail.com>
References: <1477501840-25066-1-git-send-email-amir73il@gmail.com> <1477506616-14061-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1477506616-14061-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Amir,

On Wed, Oct 26, 2016 at 8:30 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Since operations on upper are performed using mounter's credentials,
> we need to call posix_acl_update_mode() with current credentials on
> overlay inode to possibly copy-up and clear setgid bit, before setting
> posix ACLs on upper inode.

I'll let Miklos decide if this is the right approach.

> Also wrap posix acl handlers with #ifdef CONFIG_FS_POSIX_ACL to
> avoid compiler warning for implicit declaration of function
> 'posix_acl_update_mode' on build without that config option.

If you do that, make sure to remove the __maybe_unused declarations in
that file well:
they were added to silence the compiler when CONFIG_FS_POSIX_ACL isn't set. Or
else add a dummy posix_acl_update_mode function to include/linux/posix_acl.h.

Thanks,
Andreas
