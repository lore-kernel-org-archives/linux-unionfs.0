From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 0/2] Updating overlay inode i_mtime for nfsd
Date: Wed, 3 Jan 2018 17:13:20 +0200
Message-ID: <CAOQ4uxjpasf=2o--8VqWNSw981MNnbCv-SOQ_x3cM7mvvX7SFg@mail.gmail.com>
References: <1514992304-8021-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:43543 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbeACPNV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 10:13:21 -0500
In-Reply-To: <1514992304-8021-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jan 3, 2018 at 5:11 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Jeff, Bruce,
>
> These RFC patches fix an issue I found when running nfstest_posix
> over NFS exported overlayfs.
>

Wrong version posted. Sorry for the noise.

Amir.
