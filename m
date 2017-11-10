From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 13/15] ovl: Fix compression status of a metacopy only file
Date: Fri, 10 Nov 2017 11:10:35 +0200
Message-ID: <CAOQ4uxi2keQeK3C_fnby6nye0Kdka2Tb5MWiGaGEBoBQ_DaaTQ@mail.gmail.com>
References: <20171109205019.11409-1-vgoyal@redhat.com> <20171109205019.11409-14-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:48546 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751705AbdKJJKg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 04:10:36 -0500
Received: by mail-yw0-f169.google.com with SMTP id q1so7622561ywh.5
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 01:10:36 -0800 (PST)
In-Reply-To: <20171109205019.11409-14-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If file is metacopy only, it is possible that lower is compressed while
> upper is not. In that case, report file as compressed (despite the fact
> that only data is compressed while metadata is not).
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Unless I am missing something, please unify the encrypted and compressed
logic to a mask of "readonly data attributes"

Amir.
