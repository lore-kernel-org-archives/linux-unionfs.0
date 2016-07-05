From: Paul Moore <pmoore@redhat.com>
Subject: Re: [PATCH 2/5] security,overlayfs: Provide security hook for copy up
 of xattrs for overlay file
Date: Tue, 5 Jul 2016 17:45:25 -0400
Message-ID: <CAGH-KgvOe9ysM8FaUEPb4kSw6yYD_iQwRKLmbM2xX0YKZ2Xx8A@mail.gmail.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com> <1467733854-6314-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1467733854-6314-3-git-send-email-vgoyal@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jul 5, 2016 at 11:50 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Provide a security hook which is called when xattrs of a file are being
> copied up. This hook is called once for each xattr and one can either
> accept or reject xattr. If 0 is returned, xattr will be copied up, if 1
> is returned, xattr will not be copied up and if negative error code
> is returned, copy up will be aborted.
>
> In SELinux, label of lower file is not copied up. File already has been
> set with right label at the time of creation and we don't want to overwrite
> that label.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c    |  8 ++++++++
>  include/linux/lsm_hooks.h | 13 +++++++++++++
>  include/linux/security.h  | 10 ++++++++++
>  security/security.c       |  9 +++++++++
>  security/selinux/hooks.c  | 14 ++++++++++++++
>  5 files changed, 54 insertions(+)

To continue the earlier feedback about mixing generic LSM hook
definitions with the SELinux specific hook implementations - I prefer
to see patchsets organized in the following manner:

[PATCH 1/X] - add new LSM hooks and the calls from the relevant
subsystems, e.g.
{security/security.c,include/linux/security.h,fs/overlayfs/*}
[PATCH 2/X] - LSM specific hook implementation, e.g. security/selinux/*
[PATCH n/X] - LSM specific hook implementation, e.g. security/smack/*

-- 
paul moore
security @ redhat
