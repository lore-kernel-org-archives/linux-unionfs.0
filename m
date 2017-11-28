From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v8 07/15] ovl: Move the copy up helpers to copy_up.c
Date: Tue, 28 Nov 2017 21:16:58 +0200
Message-ID: <CAOQ4uxhif=NFho4FYTEv+zaaotB8pb9_eFyWnHWhM3D8DWWjZw@mail.gmail.com>
References: <20171128155959.20114-1-vgoyal@redhat.com> <20171128155959.20114-8-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:41244 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752341AbdK1TQ7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 14:16:59 -0500
Received: by mail-yw0-f172.google.com with SMTP id f1so391586ywd.8
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Nov 2017 11:16:59 -0800 (PST)
In-Reply-To: <20171128155959.20114-8-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Nov 28, 2017 at 5:59 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now two copy up helpers are in inode.c. Amir suggested it might
> be better to move these to copy_up.c.
>
> There will one more related function which will come in later patch.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
