From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 07/12] vfs: do get_write_access() on upper layer of overlayfs
Date: Wed, 19 Oct 2016 10:12:20 +0200
Message-ID: <CAJfpegtDh1xk+bAFqUqS2kbko_BXsV=zhXBx_YfeXnCn_nrjMA@mail.gmail.com>
References: <1474028371-21288-1-git-send-email-mszeredi@redhat.com>
 <1474028371-21288-8-git-send-email-mszeredi@redhat.com> <CAOQ4uxju-nD7PLtpPv8yCaN7WHPG9SPM+oaQcthv2ECqJFtKdw@mail.gmail.com>
 <CAJfpegu8dfSzKpvA5g+jPdUXxhuQwNd=TDaH6xDR2ZYt_V6QZQ@mail.gmail.com> <CAOQ4uxj5QxcGRMGT78qQf0vmjjP2Do8uaOX-B31HYXt-Wz3Fjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxj5QxcGRMGT78qQf0vmjjP2Do8uaOX-B31HYXt-Wz3Fjg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Oct 19, 2016 at 9:41 AM, Amir Goldstein <amir73il@gmail.com> wrote:

> But I noticed a strange behavior:
> When you run t_truncate_self from upper you get success for not being
> able to truncate.
> When you run t_truncate_self from lower you get an error for being
> able to truncate
> This is ok as you write, but...
> When you re-run t_truncate_self file that just got copied-up you get
> segmentation fault
> and that is not ok.
>
> You get try the patch to xfstest below to reproduce the problem:

Why would a program want to self truncate itself, except to test denywrite?

Thanks,
Miklos
