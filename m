Return-Path: <j.olszak@samsung.com>
Message-id: <558983D3.3040205@samsung.com>
Date: Tue, 23 Jun 2015 18:05:39 +0200
From: Jan Olszak <j.olszak@samsung.com>
MIME-version: 1.0
Subject: Re: Optional switching off cow in overlayfs
References: <55893699.6090109@samsung.com> <55882AA5.10908@samsung.com>
 <5582C6C1.8080602@samsung.com> <13405.1434634748@warthog.procyon.org.uk>
 <5582D8F7.1060700@samsung.com>
 <CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com>
 <5588116E.20509@samsung.com>
 <CAJfpegsVqzVhq8BjCwqA+6dEZey0aNb4amnnOT_JVDfzki9v1g@mail.gmail.com>
 <55881B2A.7090106@samsung.com>
 <CAJfpegtcUt6jR7t_2Ca1osu6+-BKGtnTVVTVXEcWrqBtY0fCzA@mail.gmail.com>
 <29219.1435051659@warthog.procyon.org.uk>
 <32715.1435065828@warthog.procyon.org.uk>
In-reply-to: <32715.1435065828@warthog.procyon.org.uk>
Content-type: multipart/alternative;
 boundary=------------050006000408080707090103
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050006000408080707090103
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 06/23/2015 03:23 PM, David Howells wrote:
> Jan Olszak <j.olszak@samsung.com> wrote:
>
>> Why not just say: "rename causes copy" and leave everything as it is now.
> That's another option - but your whole proposal was that we specifically don't
> copy up these files IIRC.
Yes, so let's modify the proposal:

Overlayfs checks xattr "trusted.overlay.cow" to switch COW off whenever 
it's possible.

 1. This would be an optimization/convenience option, not a sercurity
    option.
 2. By default overlayfs uses COW like it does now
 3. trusted.overlay.cow=="n" means:
     1. Unlink, open, setattr etc. use the original inode from lowerdir
     2. Unmodifying operations also use inode from lowerdir
     3. Other operations (rename) may copy the file if it's required by
        the implementation of overlayfs


Thanks,
Jan

--------------050006000408080707090103
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    On 06/23/2015 03:23 PM, David Howells wrote:<br>
    <blockquote cite="mid:32715.1435065828@warthog.procyon.org.uk"
      type="cite">
      <pre wrap="">Jan Olszak <a class="moz-txt-link-rfc2396E" href="mailto:j.olszak@samsung.com">&lt;j.olszak@samsung.com&gt;</a> wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="">Why not just say: "rename causes copy" and leave everything as it is now.
</pre>
      </blockquote>
      <pre wrap="">
That's another option - but your whole proposal was that we specifically don't
copy up these files IIRC.
</pre>
    </blockquote>
    Yes, so let's modify the proposal: <br>
    <br>
    Overlayfs checks xattr "trusted.overlay.cow" to switch COW off
    whenever it's possible.<br>
    <br>
    <ol>
      <li>This would be an optimization/convenience option, not a
        sercurity option.</li>
      <li>By default overlayfs uses COW like it does now<br>
      </li>
      <li>trusted.overlay.cow=="n" means:</li>
      <ol>
        <li>Unlink, open, setattr etc. use the original inode from
          lowerdir</li>
        <li>Unmodifying operations also use inode from lowerdir</li>
        <li>Other operations (rename) may copy the file if it's required
          by the implementation of overlayfs<br>
        </li>
      </ol>
    </ol>
    <br>
    Thanks,<br>
    Jan<br>
  </body>
</html>

--------------050006000408080707090103--
