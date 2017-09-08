From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: v4.13 overlay fs: sometimes fails when creating or moving files
Date: Fri, 8 Sep 2017 22:31:35 +0300
Message-ID: <CAOQ4uxhKy1uWarTyAQqXmvk5nPsLYEsb1zgfSaSv-mcxby0+6g@mail.gmail.com>
References: <20170908143704.3c74d20f@localdomain> <CAOQ4uxjC+ONu9nj-BJ8XwuWU0ofq5ySd-YRmXdikQjPAXj3WuA@mail.gmail.com>
 <CACTE=goi1H-rEKA4_2iZTsaW9k9k+kMCgnzWcZJBt4+-M93pmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:36346 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756895AbdIHTbg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Sep 2017 15:31:36 -0400
Received: by mail-yw0-f180.google.com with SMTP id v72so7965766ywa.3
        for <linux-unionfs@vger.kernel.org>; Fri, 08 Sep 2017 12:31:36 -0700 (PDT)
In-Reply-To: <CACTE=goi1H-rEKA4_2iZTsaW9k9k+kMCgnzWcZJBt4+-M93pmg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Sep 8, 2017 at 6:55 PM, Jordi Pujol <jordipujolp@gmail.com> wrote:
>
> On Fri, 8 Sep 2017 17:20:50 +0300
> Amir Goldstein <amir73il@gmail.com> wrote:
>
> > This sounds a lot like
> > https://bugzilla.redhat.com/show_bug.cgi?id=1213602 A long standing
> > issue with a simple workaround (see link above)
> >
> the problem also arises when executing
> touch /var/lib/dpkg/*
> before upgrading,
> maybe the issue is not the same,
>
> The first time replacing the file does OK, but consecutive replacements fail.
> Maybe an unitialized variable internally in overlayfs.
> > Is the problem you are hitting new to v4.13?
> Yes, this problem is new,
> therefore my computer continues running 4.12.11 by now.
>
I see. Do you see any overlay fs warning in dmesg?
Please send them as well.
I did not understand if this happens during file create
rename delete if you understand the scenario and can send a simple
reproducer script that would be great.

Thanks,
Amir.
