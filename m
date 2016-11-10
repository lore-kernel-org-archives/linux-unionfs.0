From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Thu, 10 Nov 2016 23:39:17 +0100
Message-ID: <CAJfpeguvHgWuefxfB76qPh8xGW74tuB1q3kgXvEBw5qY80xz-w@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com> <CALYGNiP=BjxrU9YLL=bGJ5yXSefGMWEAU8ni23mUipL3frjhzA@mail.gmail.com>
 <20161107134215.2v5leafss2mamim5@home.ouaza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161107134215.2v5leafss2mamim5@home.ouaza.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Raphael Hertzog <hertzog@debian.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

New version is at:

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #redirect

News:
- it actually should work in all cases
- when rename is not cross directory, just store the new name instead
of a full path, as suggested by Amir
- when redirect path is too long fall back to EXDEV (the max length
should probably be a module param)

About turning the feature on or off.  Yes, maybe the empty checking is
too complicated.  Going one simpler:

 - default to old behavior, turn on with mount option
 - add module option and kernel compile option to turn on the feature by default

I guess distros wil simply enable this by default, since back
compatibility is basically a non-issue.

Thanks,
Miklos
