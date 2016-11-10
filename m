From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Thu, 10 Nov 2016 23:02:21 +0000
Message-ID: <20161110230221.GL19539@ZenIV.linux.org.uk>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
 <1478817883-27662-5-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478817883-27662-5-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 11, 2016 at 12:44:43AM +0200, Amir Goldstein wrote:
> If work dir and upper dir have a common parent, then it
> is safe to move files between them without taking the super block
> s_vfs_rename_mutex.
> 
> Since both upper dir and work dir (as well as $workdir/work)
> are delete locked on overlay mount, they cannot be moved.

Do explain.  What do you mean, "delete locked" and why exactly can't they
be moved?
