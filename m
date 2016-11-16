From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Wed, 16 Nov 2016 23:00:28 +0100
Message-ID: <CAJfpegsKmo9zES6ZpHkjVE50z6ere3J9X2ixSFN6dhU_cEReSw@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com> <CALYGNiP=BjxrU9YLL=bGJ5yXSefGMWEAU8ni23mUipL3frjhzA@mail.gmail.com>
 <20161107134215.2v5leafss2mamim5@home.ouaza.com> <CAJfpeguvHgWuefxfB76qPh8xGW74tuB1q3kgXvEBw5qY80xz-w@mail.gmail.com>
 <CAOQ4uxiC+O93=Dbgogc-GpL_7rF-qCRXeGzy3epVfpZRHNQf=A@mail.gmail.com> <CAOQ4uxjAZAWTy14B1HA-=RmPVsgBBXve7914g0gn7EG3xADebA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjAZAWTy14B1HA-=RmPVsgBBXve7914g0gn7EG3xADebA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Raphael Hertzog <hertzog@debian.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Nov 14, 2016 at 5:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Sun, Nov 13, 2016 at 12:00 PM, Amir Goldstein <amir73il@gmail.com> wrote:

>> Looks goods, except for the case of change from relative to absolute
>> redirect of the victim dentry. IIUC, ovl_set_redirect() will return immediately
>> because ovl_dentry_is_redirect() and will not get to setting the absolute
>> redirect.
>>
>
> I added some more tests to catch this problem at:
> https://github.com/amir73il/unionmount-testsuite.git #ovl_rename_dir

Thanks for testing.

Force pushed updated version to the usual place:

   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #redirect

This also has the xattr feature thing replaced with mount option,
module param and kernel config option.

Thanks,
Miklos
