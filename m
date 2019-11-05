From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v15 0/4] overlayfs override_creds=off & nested get xattr fix
Date: Tue, 5 Nov 2019 09:56:04 +0200
Message-ID: <CAOQ4uxhoozGgxYmucFpFx8N=b4x9H3sfp60TNzf0dmU9eQi2UQ@mail.gmail.com>
References: <20191104215253.141818-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191104215253.141818-1-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Nov 4, 2019 at 11:53 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
> Patch series:
>
> Mark Salyzyn (4):
>   Add flags option to get xattr method paired to __vfs_getxattr

Sigh.. did not get to fsdevel (again...) I already told you several times
that you need to use a shorter CC list.

>   overlayfs: handle XATTR_NOSECURITY flag for get xattr method
>   overlayfs: internal getxattr operations without sepolicy checking
>   overlayfs: override_creds=off option bypass creator_cred

It would be better for review IMO if you rebase your series on top of
git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git ovl-unpriv

1. internal getxattr patch would be a one liner change to ovl_own_getxattr()
2. The documentation of override_creds would be much more
meaningful if it used the overlay permission model terminology
that Miklos added in his patch set and extend it

Thanks,
Amir.
