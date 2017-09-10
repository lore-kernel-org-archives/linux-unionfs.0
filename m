From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: v4.13 overlay fs: sometimes fails when creating or moving files
Date: Sun, 10 Sep 2017 22:21:09 +0300
Message-ID: <CAOQ4uxjEMJUGesER22p_wE2THejhNCobdcyOEZb5YffR9uKD2w@mail.gmail.com>
References: <20170908143704.3c74d20f@localdomain> <CAOQ4uxjC+ONu9nj-BJ8XwuWU0ofq5ySd-YRmXdikQjPAXj3WuA@mail.gmail.com>
 <CACTE=goi1H-rEKA4_2iZTsaW9k9k+kMCgnzWcZJBt4+-M93pmg@mail.gmail.com>
 <CAOQ4uxhKy1uWarTyAQqXmvk5nPsLYEsb1zgfSaSv-mcxby0+6g@mail.gmail.com> <CACTE=gp1JRmVtY_SR4YRx5CsPPFrrPsgbxq=JYH_VYRq8rQZsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:33211 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbdIJTVK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 10 Sep 2017 15:21:10 -0400
Received: by mail-yw0-f169.google.com with SMTP id s62so17760944ywg.0
        for <linux-unionfs@vger.kernel.org>; Sun, 10 Sep 2017 12:21:10 -0700 (PDT)
In-Reply-To: <CACTE=gp1JRmVtY_SR4YRx5CsPPFrrPsgbxq=JYH_VYRq8rQZsw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Sun, Sep 10, 2017 at 5:10 PM, Jordi Pujol <jordipujolp@gmail.com> wrote:
> This error disappears after installing 4.13.1, but other problems have
> arised when unmounting some kind of filesystems.
>

That is strage, because I see nothing fs related in v4.13..v4.13.1
which umount problems are you referring to?

> Maybe it was not an overlayfs error.
>

Ehm.. maybe, but considering the changes in overlayfs for v4.13
I cannot rule out that we missed some subtle race with overlay inode
cache that would change behavior.

Also, I did not test much with lower fs that does not support file handles,
and that is the case in your setup, so there might be a bug hiding there.

Please keep us posted if the errors make a comeback.

Thanks,
Amir.
