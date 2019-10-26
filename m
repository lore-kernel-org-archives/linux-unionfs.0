From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 4/5] ovl: user xattr
Date: Sat, 26 Oct 2019 16:50:34 +0300
Message-ID: <CAOQ4uxhRfDq49s-NCP5JK5VSYCZ+LXv2oMeyOReoLqq8LePkuQ@mail.gmail.com>
References: <20191025112917.22518-1-mszeredi@redhat.com> <20191025112917.22518-5-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191025112917.22518-5-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 25, 2019 at 10:54 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> Optionally allow using "user.overlay" namespace instead
> of"trusted.overlay".
>
> This is necessary for overlayfs to be able to be mounted in an unprivileged
> namepsace.
>
> Make the option explicit, since it makes the filesystem format be
> incompatible.
>

Ach! this was tiring..
If you get to resubmit, please consider separating the plumbing
from the userxattr implementation.

Thanks,
Amir.
