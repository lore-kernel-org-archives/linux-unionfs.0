From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH v2] ovl: don't follow redirects if redirect_dir=off
Date: Mon, 11 Dec 2017 10:33:28 +0100
Message-ID: <CAJfpegsSNx_D+rEP+oe5+Pf-hoEVu-JRc7t8SqBA4uy9PRRaFA@mail.gmail.com>
References: <20171206150333.GB24303@veci.piliscsaba.redhat.com> <30533.1512743808@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:45815 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbdLKJda (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Dec 2017 04:33:30 -0500
Received: by mail-qt0-f175.google.com with SMTP id g10so36722950qtj.12
        for <linux-unionfs@vger.kernel.org>; Mon, 11 Dec 2017 01:33:29 -0800 (PST)
In-Reply-To: <30533.1512743808@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>

On Fri, Dec 8, 2017 at 3:36 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> +     const char *redirect_mode;
>> ...
>> +     kfree(ofs->config.redirect_mode);
>
> That's going to get you a compiler warning under some circumstances.

How so?  kfree() takes const void *, which is compatible with const char *.

>
>> +                     config->redirect_mode = match_strdup(&args[0]);
>
> We shouldn't really be copying the string if we can help it, though I grant we
> may not have the match_*() function to do otherwise at the moment.  I would
> much prefer seeing it rendered to an enum value at this point.

I think that's going into the bike shedding territory, and this shed
is mine, so there ;-p

Thanks,
Miklos
