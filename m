From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: handle ENOENT on index lookup
Date: Fri, 20 Oct 2017 14:42:40 +0300
Message-ID: <CAOQ4uxgBfGX7w6GN_Vk4YpQt332kuvjE9-8UqXqNT3pxFZeNag@mail.gmail.com>
References: <1508497270-27971-1-git-send-email-amir73il@gmail.com> <20171020113712.GB699@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:44631 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752628AbdJTLml (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:42:41 -0400
In-Reply-To: <20171020113712.GB699@kroah.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, "# v4 . 13" <stable@vger.kernel.org>

On Fri, Oct 20, 2017 at 2:37 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Oct 20, 2017 at 02:01:10PM +0300, Amir Goldstein wrote:
>> Fixes: 359f392ca53e ("ovl: lookup index entry for copy up origin")
>> Cc: <stable@vger.kernel.org> # v4.13
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Why is there no changelog at all?  Not good, especially for a patch
> wanting to be sent to the stable trees :(
>

Yeh, sorry about that. I was hoping it'd get squashed into an earlier
patch which is on overlayfs-next of today and not yet pulled into linux-next.
Or rejected.
If that doesn't happen, I'll re-post with commit message.

Amir.
