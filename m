From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/5] VFS API for getting filesystem's UUID
Date: Thu, 27 Apr 2017 11:09:06 +0200
Message-ID: <CAJfpegs=zMQzzVep7uJwvZp0ujw1kSK8VSEszcKB-VzeHAvCKg@mail.gmail.com>
References: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33416 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031468AbdD0JJH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 05:09:07 -0400
Received: by mail-oi0-f51.google.com with SMTP id y11so30472089oie.0
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2017 02:09:07 -0700 (PDT)
In-Reply-To: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Thu, Apr 27, 2017 at 10:59 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> As you observed, the sb->s_uuid field is not always filled by filesystems.
>
> Consumers, like overlayfs, that wish to use this field can check if is
> zeroed out as an indication for valid value.
>
> Christoph suggested to make the test more explicit and require the
> filesystems that fill the s_uuid field to set a super block flag.
>
> Do you agree with the proposed API?

Sure.

Thanks,
Miklos
