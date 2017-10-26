From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 04/13] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Thu, 26 Oct 2017 08:39:28 +0300
Message-ID: <CAOQ4uxhV3-8ytms+M5n2QVYGmZJNL527H7KYpXnzbE93fOsBdA@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com> <1508958575-14086-5-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:44127 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbdJZFj3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 01:39:29 -0400
Received: by mail-yw0-f194.google.com with SMTP id k11so1988998ywh.1
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Oct 2017 22:39:29 -0700 (PDT)
In-Reply-To: <1508958575-14086-5-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> By default metadata only copy up is disabled. Provide a mount option so
> that users can choose one way or other.
>
> Also provide a kernel config and module option to enable/disable
> metacopy feature.
>
> Like index feature, when overlay is mounted, on root upper directory we
> set ORIGIN which points to lower. And at later mount time it is verified
> again. This hopes to get the configuration right. But this does only so
> much as we don't verify all the lowers. So it is possible that a lower is
> missing and later data copy up fails.

Since you bother to specify the motivation for verifying lower root dir,
FYI, the main motivation was to detect the case of copied layers.
I still hold the opinion that new incompat features should enforce
exclusive dir lock, so withholding Reviewed-by on this one for now.
