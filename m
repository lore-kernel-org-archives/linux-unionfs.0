From: Marko Rauhamaa <marko.rauhamaa@f-secure.com>
Subject: Re: [PATCH] ovl: don't expose EOPENSTALE to userspace
Date: Thu, 27 Apr 2017 10:40:57 +0300
Message-ID: <87tw5a47sm.fsf@drapion.f-secure.com>
References: <1493128675-24331-1-git-send-email-amir73il@gmail.com>
        <20170426134731.GB5214@veci.piliscsaba.szeredi.hu>
        <8737cv5kli.fsf@drapion.f-secure.com>
        <CAOQ4uxiODuLDYLouWJppgPkew16tTeOTxk+UTmP6Bdt2fJY6Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxiODuLDYLouWJppgPkew16tTeOTxk+UTmP6Bdt2fJY6Mw@mail.gmail.com>
        (Amir Goldstein's message of "Wed, 26 Apr 2017 18:45:54 +0300")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Tyler Hicks <tyhicks@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "stable [v4.9]" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Amir Goldstein <amir73il@gmail.com>:
> There are more error that you can get same way that you got
> EOPENSTALE. The fact that I filtered EOPENSTALE is fixing a POSIX bug,
> but it does not fix the general problem you described.
>
> For example, I know you can get ENODEV, because I got it on
> out test env. This is the case of a "stale device node" - by the time
> you get to read an access event generated on a device file, the device
> that this file represents does not exists and cannot be opened.
>
> As with the case of EOPENSTALE, your app should just read again
> when that happens.

Thing is, I must treat every unknown error value as critical and exit.
That's because the problem might be persistent and spinning in a read
loop hangs the system.

Unless, of course, the system call API explicitly declares all problems
as transient and tells the application to retry indefinitely. ENODEV
certainly doesn't have the ring of a transient error.

I don't really see why read(2) on the fanotify fd should return any
random errors. The fanotify fd is purely a software device and should
only have a fixed, documented set of failure modes. The other file
descriptor (metadata->fd) is tied to a real file and could fail in a
million ways; that's understandable.


Marko

-- 
+358 44 990 4795
Skype: marko.rauhamaa_f-secure
