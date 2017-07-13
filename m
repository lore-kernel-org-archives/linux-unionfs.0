From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Thu, 13 Jul 2017 22:19:02 +0200
Message-ID: <CAJfpegtk9RiN6cwKXRHoh9i+_tOgYyW+PFkrwEXvit_J9Pm3cw@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com> <1499777923-29410-11-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33512 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752891AbdGMUTE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2017 16:19:04 -0400
Received: by mail-oi0-f68.google.com with SMTP id f134so7986478oig.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2017 13:19:04 -0700 (PDT)
In-Reply-To: <1499777923-29410-11-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Jul 11, 2017 at 2:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> When inodes index feature is enabled, if lower dir does not match the
> origin fh stored in upper dir, or if no lower dir was found by name,
> try to decode the stored origin fh and use the result as the merge dir
> lower dentry.
>
> This change is needed for indexing of merge directories. A merge
> directory is indexed by the file handle of the uppermost lower dir and
> the index will have a reference to the upper dir by file handle.
> Following down from upper by origin file handle ensures the integrity
> of the index for non-stale origin entries. index entries with stale origin
> are going to be cleaned up on mount anyway.

Not sure I understand.  In what case is following down by origin needed?

Thanks,
Miklos
