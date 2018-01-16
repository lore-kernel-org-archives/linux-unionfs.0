From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 7/7] overlay: test encode/decode of non-samefs overlay
 file handles
Date: Tue, 16 Jan 2018 10:46:13 +0200
Message-ID: <CAOQ4uximWKVc+DO5pU+06CM7yJWY5Q8cQ=gTmWqesu9CgAmW8g@mail.gmail.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
 <1515348445-1403-8-git-send-email-amir73il@gmail.com> <20180116074228.GI3102@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:41557 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeAPIqO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 Jan 2018 03:46:14 -0500
In-Reply-To: <20180116074228.GI3102@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 16, 2018 at 9:42 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Sun, Jan 07, 2018 at 08:07:25PM +0200, Amir Goldstein wrote:
>> This is a variant of overlay file handles test for an overlayfs that
>> is composed of multiple lower layers not on the same underlying fs.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> This test follows the same pattern of overlay/050, I just noticed one
> other issue. We don't have _overlay_check_dirs yet, so test failed
> complaining (apart from the "+open_by_handle() returned 116 incorrectly
> on a linked dir!" issue):
>
> +./tests/overlay/051: line 126: _overlay_check_dirs: command not found
>

My bad, I re-ordered patches and forgot to remove these.

Thanks,
Amir.
