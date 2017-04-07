From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Fri, 7 Apr 2017 11:43:25 +0200
Message-ID: <CAJfpeguDNDfZXSpep9PRNjyQPQ=DqZNFioUw=+gp4SjbbxU2BA@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com>
 <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com> <CAOQ4uxhyBeMxVCrj44Nz1L=Cy5NmqJdNCp4XV==6m6jJCv9YiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36738 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755961AbdDGJn0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 05:43:26 -0400
Received: by mail-oi0-f43.google.com with SMTP id r203so80008516oib.3
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Apr 2017 02:43:26 -0700 (PDT)
In-Reply-To: <CAOQ4uxhyBeMxVCrj44Nz1L=Cy5NmqJdNCp4XV==6m6jJCv9YiQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Apr 6, 2017 at 6:46 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Yes, but do you think we should delay consistent_fd until we have a full
> solution for constant_ino?
> Do you think it is acceptable to fix only stat (to return lower ino) and leave
> readdir d_ino for later?

I don't know, because, as we discussed previously, these are really
luxury bugs, and there's no push for either from real use cases.  So
I'd add fixes in the order of becoming the obviously right fix.  I
think we are closer to getting the constant ino resolved properly than
consistent fd.

I really want to look into sharing pages between clones.
"Unfortunately" I'll be taking next week off, so...

Thanks,
Miklos
