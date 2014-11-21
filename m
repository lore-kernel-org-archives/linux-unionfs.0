From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlay filesystem fixes for 3.18
Date: Fri, 21 Nov 2014 11:50:24 +0100
Message-ID: <CAJfpegs6iF+O9W40k+L=kmydZA7O20H6aYdwtTF1vEsq4790xw@mail.gmail.com>
References: <20141120164531.GB3596@tucsk>
	<CA+icZUVSdSDqUCf3+2SmGx4DfhKvxPi4ivvhNzTEnbe1j4eFQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48039 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233AbaKUKu0 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 21 Nov 2014 05:50:26 -0500
Received: by mail-qc0-f174.google.com with SMTP id c9so3493494qcz.19
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Nov 2014 02:50:25 -0800 (PST)
In-Reply-To: <CA+icZUVSdSDqUCf3+2SmGx4DfhKvxPi4ivvhNzTEnbe1j4eFQA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Fri, Nov 21, 2014 at 11:43 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-current
>>
>
> This seems to be the place where overlayfs-fixes are collected for a
> git-pull request.
> Can you add a "T:" line with the Git tree into MAINTAINERS file if
> this is the case?

Done that already.  See "ovl: update MAINTAINERS" patch in that series.

Thanks,
Miklos
