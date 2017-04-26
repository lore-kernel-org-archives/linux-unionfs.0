From: Marko Rauhamaa <marko.rauhamaa@f-secure.com>
Subject: Re: [PATCH] ovl: don't expose EOPENSTALE to userspace
Date: Wed, 26 Apr 2017 17:06:49 +0300
Message-ID: <8737cv5kli.fsf@drapion.f-secure.com>
References: <1493128675-24331-1-git-send-email-amir73il@gmail.com>
        <20170426134731.GB5214@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170426134731.GB5214@veci.piliscsaba.szeredi.hu> (Miklos
        Szeredi's message of "Wed, 26 Apr 2017 15:47:31 +0200")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Tyler Hicks <tyhicks@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu>:

> I'm looking at the EOPENSTALE story and it very much looks like we can
> just replace the single use with ESTALE and handle the lookup retry
> logic nuances inside the lookup code...

The fanotify problem is not simply a matter of choosing a POSIX name for
an error. The question is, what problems should an fanotify application
be prepared to handle and what should it do about them?

Since a misbehaving fanotify application is likely to hang the entire
operating system, it needs very clear guidelines for correct behavior.
In particular, when the application does a read(2) on an fanotify file
descriptor and gets back an error code, how is the application to
recover gracefully and safely?

Amir's patch shields the fanotify application from EOPENSTALE. I would
very much like an extensive list of errors that read(2) on a fanotify fd
can return. As it stands, I'm only aware of EAGAIN in the nonblocking
case and EINTR in the blocking case -- and even those haven't been
explicitly documented.


Marko
