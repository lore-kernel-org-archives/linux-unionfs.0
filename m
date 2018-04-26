From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH 09/35] ovl: stack file ops
Date: Thu, 26 Apr 2018 17:21:40 +0200
Message-ID: <CAJfpegundJm30UnRCtfJPWZqou7evbhovW3Q5Wo-4HSy5g4wZA@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <20180412150826.20988-10-mszeredi@redhat.com>
 <20180426141337.GA4308@redhat.com> <CAJfpegv9by9L_b-STRMy4U8Uqv03UrOYDuAa3HdF-9zKxZQRcA@mail.gmail.com>
 <20180426145641.GB4308@redhat.com> <CAJfpeguCtZ+3q6Fr7bu1Q5B3JXFQfS2Y9XJHgr0-OR9g=J9JsA@mail.gmail.com>
 <20180426151305.GC4308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426151305.GC4308@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Apr 26, 2018 at 5:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:

> Aha, cool. thanks. While I am at it, let me just ask one more stupid
> question.
>
> I am wondering while opening the underlying realfile, why do we pass
> in the path/dentry of ovl layer (and not underlying real layer).
>
>         realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
>                              realinode, current_cred(), false);
>
> This forces us to do file_dentry() in ovl_open() later to map top level
> dentry to underlying dentry.
>
> We know the realinode and should be figure out real dentry. Can't we
> construct path from underlying dentry and mount point and use that
> to open underlying real file.  I am sure there is some reason for doing
> this way, just trying to understand it.

The logical thing would be to just use the real path (as returned by
ovl_path_real()).

The reason we don't do that is because mmap stores the real file in
vma->vm_file and vm_file->f_path is used in various places (e.g.
/proc/PID/maps).

We could have a separate realfile for mmap, but that would be
additional complexity and memory use, so I don't think it makes sense.

Thanks,
Miklos
