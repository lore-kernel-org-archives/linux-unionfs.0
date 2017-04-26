From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: don't expose EOPENSTALE to userspace
Date: Wed, 26 Apr 2017 18:45:54 +0300
Message-ID: <CAOQ4uxiODuLDYLouWJppgPkew16tTeOTxk+UTmP6Bdt2fJY6Mw@mail.gmail.com>
References: <1493128675-24331-1-git-send-email-amir73il@gmail.com>
 <20170426134731.GB5214@veci.piliscsaba.szeredi.hu> <8737cv5kli.fsf@drapion.f-secure.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36314 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936823AbdDZPqG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 11:46:06 -0400
In-Reply-To: <8737cv5kli.fsf@drapion.f-secure.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Marko Rauhamaa <marko.rauhamaa@f-secure.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Tyler Hicks <tyhicks@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "stable [v4.9]" <stable@vger.kernel.org>

On Wed, Apr 26, 2017 at 5:06 PM, Marko Rauhamaa
<marko.rauhamaa@f-secure.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu>:
>
>> I'm looking at the EOPENSTALE story and it very much looks like we can
>> just replace the single use with ESTALE and handle the lookup retry
>> logic nuances inside the lookup code...
>
> The fanotify problem is not simply a matter of choosing a POSIX name for
> an error. The question is, what problems should an fanotify application
> be prepared to handle and what should it do about them?
>
> Since a misbehaving fanotify application is likely to hang the entire
> operating system, it needs very clear guidelines for correct behavior.
> In particular, when the application does a read(2) on an fanotify file
> descriptor and gets back an error code, how is the application to
> recover gracefully and safely?
>
> Amir's patch shields the fanotify application from EOPENSTALE. I would
> very much like an extensive list of errors that read(2) on a fanotify fd
> can return. As it stands, I'm only aware of EAGAIN in the nonblocking
> case and EINTR in the blocking case -- and even those haven't been
> explicitly documented.
>

There are more error that you can get same way that you got
EOPENSTALE. The fact that I filtered EOPENSTALE is fixing a POSIX bug,
but it does not fix the general problem you described.

For example, I know you can get ENODEV, because I got it on
out test env. This is the case of a "stale device node" - by the time
you get to read an access event generated on a device file, the device
that this file represents does not exists and cannot be opened.

As with the case of EOPENSTALE, your app should just read again
when that happens.

You can either get the error from read() or not. This is documented in
man page:
       *  If  a  call  to  read(2) processes multiple events from the fanotify
          queue and an error occurs, the return value will be the total length
          of the events successfully copied to the user-space buffer before
          the error occurred.  The return value will not be -1, and errno will
          not be set.  Thus, the reading application has no way to
detect the error.


Amir.
