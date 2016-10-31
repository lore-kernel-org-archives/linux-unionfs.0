From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 31 Oct 2016 15:59:54 +0100
Message-ID: <CAOssrKdfoffq2AZvYkDY1gkYbmj=BJ=-jaqGx3v1ReAfBgf6ug@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <CAOQ4uxhTOw9vHVSQURakYgamXMxXDTnZYFjUDZYx1Hnf=TA9dA@mail.gmail.com>
 <CAJfpegs+NDycOda67y5-8zDYHk90gxdQuQsRQ2pLq58UcUqa9A@mail.gmail.com> <CAOQ4uxgqGkioGZ9=rG3+m-SQEBCGH-9zvsC0-+KtRP0yuL0jRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxgqGkioGZ9=rG3+m-SQEBCGH-9zvsC0-+KtRP0yuL0jRQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Oct 30, 2016 at 11:00 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> I have a POC for generic addition of layers for unionmount-testsuite
> I pushed it to my github:
> https://github.com/amir73il/unionmount-testsuite.git #ovl_rename_dir

Cool.  But... this seems to be missing the "remount_union" module.

Thanks,
Miklos
