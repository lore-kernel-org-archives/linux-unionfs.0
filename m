From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH 00/13] overlayfs stable inodes
Date: Thu, 20 Apr 2017 10:47:15 +0200
Message-ID: <CAJfpegu8CkOzFeBi-f8_LopH9yWY8YAhhD1EbO03fAWEU-3vqQ@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgtiDr9GEgjAsRHLeOo=HTobf-qwZ0bZLyjrhLyNiTt4A@mail.gmail.com>
 <CAJfpegsQTd8SgHRFcuEJMgjLjNW45vyuUiPPKZLC4bv_OJOmGA@mail.gmail.com>
 <CAOQ4uxh1VmeB1WGuP4sXyzR0oeQ_ux2hd+9vXM=UbsL+cxTwXQ@mail.gmail.com>
 <CAJfpegumzAZbvyWgfYaLtG1L7LF_Ob2zgA55Hz5H5Ctv7DoJ=Q@mail.gmail.com>
 <CAOQ4uxi0vRsyY2jrS_baaZ3n+d0Fx+6fDWj2Wm=4ZEGAZGHzDQ@mail.gmail.com>
 <CAJfpegsDMfM066PvoQup5SwS3exmfM23+2EWiUsuGROZvN3H_g@mail.gmail.com>
 <CAOQ4uxjWvgKr02-D-HwnGwrpoq165W++aOxddRUHhDFvv8bB7w@mail.gmail.com>
 <20170419225837.GE5205@birch.djwong.org> <940D64D5-55A8-45D1-844F-41872B2FEBB6@dilger.ca>
 <CAJfpeguojvzDKN3bPqbwxxAJ+G2bfH3eO3Oe+H4AAcZp9Svwzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33562 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943725AbdDTIrR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2017 04:47:17 -0400
Received: by mail-oi0-f48.google.com with SMTP id y11so8955001oie.0
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2017 01:47:16 -0700 (PDT)
In-Reply-To: <CAJfpeguojvzDKN3bPqbwxxAJ+G2bfH3eO3Oe+H4AAcZp9Svwzg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Amir Goldstein <amir73il@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Thu, Apr 20, 2017 at 10:45 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Ideally we'd want dynamically sized inode numbers and we have that:
> file handles.  But file handles do more than inode numbers and they
> are more heavyweight.

And even more importantly, we can't force userspace to *use* file
handles instead of st_ino.  So that doesn't work.

Thanks,
Miklos
