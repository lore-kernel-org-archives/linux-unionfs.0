From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/4] src/open_by_handle: helper to test
 open_by_handle_at() syscall
Date: Wed, 19 Apr 2017 13:08:57 +0300
Message-ID: <CAOQ4uxg6WMYLFB=GwCRyb3UiJFYDBhoBfERacG9niVtnXXxM_Q@mail.gmail.com>
References: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
 <1492539444-25938-2-git-send-email-amir73il@gmail.com> <9896.1492595482@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <9896.1492595482@warthog.procyon.org.uk>
Sender: fstests-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 19, 2017 at 12:51 PM, David Howells <dhowells@redhat.com> wrote:
> Amir Goldstein <amir73il@gmail.com> wrote:
>
>> This is a clone of src/stale_handle.c test that uses generic
>> open_by_handle_at() syscall instead of the xfs specific ioctl.
>
> Don't forget to add it to doc/auxiliary-programs.txt!
>

Will do :) Thanks!
